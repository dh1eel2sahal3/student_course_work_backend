const express = require("express");
const router = express.Router();

const {
  createCoursework,
  getCourseworks,
  getCoursework,
  updateCoursework,
  deleteCoursework,
} = require("../controllers/courseWorkController");

const { protect, authorize } = require("../middleware/authMiddleware");

// Teacher / Admin
router.post("/", protect, authorize("admin", "teacher"), createCoursework);
router.put("/:id", protect, authorize("admin", "teacher"), updateCoursework);
router.delete("/:id", protect, authorize("admin", "teacher"), deleteCoursework);

// Logged users
router.get("/", protect, getCourseworks);
router.get("/:id", protect, getCoursework);

module.exports = router;