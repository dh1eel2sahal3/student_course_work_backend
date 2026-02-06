const express = require("express");
const router = express.Router();

const {
  createSubmission,
  getAllSubmissions,
  getMySubmissions,
  giveMarks,
} = require("../controllers/submissionController");

const { protect, authorize } =
  require("../middleware/authMiddleware");

// STUDENT → submit coursework
router.post("/", protect, authorize("student"), createSubmission);

// STUDENT → view my submissions
router.get("/my-submissions", protect, authorize("student"), getMySubmissions);

// ADMIN → view all submissions
router.get("/", protect, authorize("admin"), getAllSubmissions);

// ADMIN → give marks
router.put("/:id", protect, authorize("admin"), giveMarks);

module.exports = router;