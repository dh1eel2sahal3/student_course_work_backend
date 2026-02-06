const Submission = require("../models/submission");

/* STUDENT → SUBMIT COURSEWORK */
exports.createSubmission = async (req, res) => {
  try {
    const { coursework, answer } = req.body;

    if (!coursework || !answer) {
      return res.status(400).json({
        message: "Coursework iyo answer waa qasab",
      });
    }

    const submission = await Submission.create({
      coursework,
      answer,
      student: req.user.id, // ka imanaya token
    });

    res.status(201).json({
      message: "Submission waa la diray",
      submission,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

/* ADMIN → VIEW ALL SUBMISSIONS */
exports.getAllSubmissions = async (req, res) => {
  try {
    const submissions = await Submission.find()
      .populate("student", "username role firstName lastName")
      .populate({
        path: "coursework",
        select: "title description deadline course",
        populate: {
          path: "course",
          select: "title code"
        }
      });

    res.json(submissions);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

/* STUDENT → VIEW MY SUBMISSIONS */
exports.getMySubmissions = async (req, res) => {
  try {
    const submissions = await Submission.find({ student: req.user.id })
      .populate({
        path: "coursework",
        select: "title description deadline course",
        populate: {
          path: "course",
          select: "title code"
        }
      })
      .sort({ createdAt: -1 });

    res.json(submissions);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

/* ADMIN → GIVE MARKS */
exports.giveMarks = async (req, res) => {
  try {
    const { marks } = req.body;

    const submission = await Submission.findByIdAndUpdate(
      req.params.id,
      { marks },
      { new: true }
    )
      .populate("student", "username role firstName lastName")
      .populate({
        path: "coursework",
        select: "title description deadline course",
        populate: {
          path: "course",
          select: "title code"
        }
      });

    if (!submission) {
      return res.status(404).json({ message: "Submission lama helin" });
    }

    res.json({
      message: "Marks waa la bixiyay",
      submission,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};