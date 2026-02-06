const mongoose = require("mongoose");

const submissionSchema = new mongoose.Schema(
  {
    coursework: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Coursework",
      required: true,
    },
    answer: {
      type: String,
      required: true,
    },
    student: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    marks: {
      type: Number,
      default: null,
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Submission", submissionSchema);