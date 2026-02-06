const Coursework = require("../models/coursework");

/* CREATE */
exports.createCoursework = async (req, res) => {
  try {
    const coursework = await Coursework.create({
      ...req.body,
      createdBy: req.user._id,
    });

    res.status(201).json(coursework);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

/* READ ALL */
exports.getCourseworks = async (req, res) => {
  try {
    const courseworks = await Coursework.find()
      .populate("course", "title code")
      .populate("createdBy", "username role");

    res.json(courseworks);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

/* READ ONE */
exports.getCoursework = async (req, res) => {
  try {
    const coursework = await Coursework.findById(req.params.id);
    if (!coursework) {
      return res.status(404).json({ message: "Coursework lama helin" });
    }
    res.json(coursework);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

/* UPDATE */
exports.updateCoursework = async (req, res) => {
  try {
    const coursework = await Coursework.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true }
    );
    res.json(coursework);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

/* DELETE */
exports.deleteCoursework = async (req, res) => {
  try {
    await Coursework.findByIdAndDelete(req.params.id);
    res.json({ message: "Coursework waa la tirtiray" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};