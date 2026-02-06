const express = require("express");
const router = express.Router();

const {
  createCourse,
  getCourses,
  getCourse,
  updateCourse,
  deleteCourse,
} = require("../controllers/courseController");

const { protect, authorize } = require("../middleware/authMiddleware");

// CREATE (admin / teacher)
router.post("/", protect, authorize("admin", "teacher"), createCourse);

// READ
router.get("/", protect, getCourses);
router.get("/:id", protect, getCourse);

// UPDATE (admin / teacher)
router.put("/:id", protect, authorize("admin", "teacher"), updateCourse);

// DELETE (admin only)
router.delete("/:id", protect, authorize("admin"), deleteCourse);

module.exports = router;