const User = require("../models/user");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");

/* REGISTER */
exports.register = async (req, res) => {
  try {
    const { firstName, lastName, sex, username, password, role } = req.body;

    // Hubin
    if (!firstName || !lastName || !sex || !username || !password) {
      return res.status(400).json({
        message: "Dhamaan fields-ka waa qasab",
      });
    }

    const exist = await User.findOne({ username });
    if (exist) {
      return res.status(400).json({
        message: "Username hore ayuu u jiraa",
      });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    await User.create({
      firstName,
      lastName,
      sex,
      username,
      password: hashedPassword,
      role,
    });

    res.status(201).json({
      message: "User registered successfully",
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

/* LOGIN */
exports.login = async (req, res) => {
  try {
    const { username, password } = req.body;

    if (!username || !password) {
      return res.status(400).json({
        message: "Username iyo password waa qasab",
      });
    }

    const user = await User.findOne({ username });
    if (!user) {
      return res.status(404).json({
        message: "User lama helin",
      });
    }

    if (!user.isActive) {
      return res.status(403).json({
        message: "Account waa la xiray",
      });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(401).json({
        message: "Password khaldan",
      });
    }

    const token = jwt.sign(
      { id: user._id, role: user.role },
      process.env.JWT_SECRET,
      { expiresIn: "1d" }
    );

    res.json({ token });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

/* GET ALL USERS */
exports.getUsers = async (req, res) => {
  try {
    const users = await User.find().select("-password");
    res.json(users);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

/* UPDATE USER */
exports.updateUser = async (req, res) => {
  try {
    const { firstName, lastName, sex, username, role, isActive } = req.body;

    // Isku day in la saxo hadii username-ka la badalayo inuusan hore u jirin
    if (username) {
      const existingUser = await User.findOne({
        username,
        _id: { $ne: req.params.id }
      });
      if (existingUser) {
        return res.status(400).json({ message: "Username-kaan hore ayaa loo qaatay" });
      }
    }

    const user = await User.findByIdAndUpdate(
      req.params.id,
      { firstName, lastName, sex, username, role, isActive },
      { new: true, runValidators: true }
    ).select("-password");

    if (!user) {
      return res.status(404).json({ message: "User lama helin" });
    }

    res.json(user);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

/* DELETE USER */
exports.deleteUser = async (req, res) => {
  try {
    const user = await User.findByIdAndDelete(req.params.id);
    if (!user) {
      return res.status(404).json({ message: "User lama helin" });
    }
    res.json({ message: "User waa la tirtiray" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
