const Course = require("../models/course");

/* CREATE COURSE */
exports.createCourse = async (req, res) => {
  try {
    const { title, code, description } = req.body;

    if (!title || !code) {
      return res.status(400).json({ message: "Title iyo code waa qasab" });
    }

    const course = await Course.create({
      title,
      code,
      description,
      createdBy: req.user._id, // token ka yimid
    });

    res.status(201).json(course);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

/* GET ALL COURSES */
exports.getCourses = async (req, res) => {
  try {
    const courses = await Course.find().populate(
      "createdBy",
      "username role"
    );
    res.json(courses);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

/* GET SINGLE COURSE */
exports.getCourse = async (req, res) => {
  try {
    const course = await Course.findById(req.params.id);
    if (!course) {
      return res.status(404).json({ message: "Course lama helin" });
    }
    res.json(course);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

/* UPDATE COURSE */
exports.updateCourse = async (req, res) => {
  try {
    const course = await Course.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true }
    );

    if (!course) {
      return res.status(404).json({ message: "Course lama helin" });
    }

    res.json(course);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

/* DELETE COURSE */
exports.deleteCourse = async (req, res) => {
  try {
    const course = await Course.findByIdAndDelete(req.params.id);
    if (!course) {
      return res.status(404).json({ message: "Course lama helin" });
    }
    res.json({ message: "Course waa la tirtiray" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};