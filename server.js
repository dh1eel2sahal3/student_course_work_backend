const express = require("express");
const dotenv = require("dotenv");
const cors = require("cors");
const connectDB = require("./config/db");

// ENV
dotenv.config();

// App
const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// DB
connectDB();

// ================= LOAD MODELS =================
require("./models/user");
require("./models/course");
require("./models/coursework");
require("./models/submission");

// ================= ROUTES =================
const authRoutes = require("./routes/authRoutes");
const courseRoutes = require("./routes/courseRoutes");
const courseworkRoutes = require("./routes/courseWorkRoutes");
const submissionRoutes = require("./routes/submissionRoutes");

// ================= USE ROUTES =================
app.use("/api/auth", authRoutes);
app.use("/api/courses", courseRoutes);
app.use("/api/courseworks", courseworkRoutes);
app.use("/api/submissions", submissionRoutes);

// ================= AUTH MIDDLEWARE =================
const { protect, authorize } = require("./middleware/authMiddleware");

// Test routes
app.get("/api/test/protected", protect, (req, res) => {
  res.json({
    message: "User login ayuu galay ✅",
    user: req.user,
  });
});

app.get("/api/test/admin", protect, authorize("admin"), (req, res) => {
  res.json({ message: "Admin only ✅" });
});

// Root
app.get("/", (req, res) => {
  res.send("🚀 Student Coursework API Running");
});

// ================= SERVER =================
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`✅ Server running on port ${PORT}`);
});