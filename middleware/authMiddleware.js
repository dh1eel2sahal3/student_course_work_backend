const jwt = require("jsonwebtoken");
const User = require("../models/user");

// =====================
// PROTECT (login check)
// =====================
exports.protect = async (req, res, next) => {
  let token;

  if (
    req.headers.authorization &&
    req.headers.authorization.startsWith("Bearer")
  ) {
    try {
      // Bearer TOKEN
      token = req.headers.authorization.split(" ")[1];

      // Verify token
      const decoded = jwt.verify(token, process.env.JWT_SECRET);

      // Hel user
      const user = await User.findById(decoded.id).select("-password");

      if (!user) {
        return res.status(401).json({ message: "User lama helin" });
      }

      if (user.isActive === false) {
        return res.status(403).json({ message: "Account waa la xiray" });
      }

      req.user = user;
      next();
    } catch (err) {
      return res.status(401).json({ message: "Token sax ma aha" });
    }
  } else {
    return res.status(401).json({ message: "Token lama helin" });
  }
};

// =====================
// AUTHORIZE (role check)
// =====================
exports.authorize = (...roles) => {
  return (req, res, next) => {
    if (!req.user || !roles.includes(req.user.role)) {
      return res.status(403).json({
        message: "Ma lihid fasax (role) aad ku sameyso ficilkan",
      });
    }
    next();
  };
};