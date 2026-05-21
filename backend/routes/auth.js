const express = require('express');
const {
  registerUser,
  loginUser,
  resetPassword,
  checkPhoneExists,
} = require('../controllers/authController');

const router = express.Router();

router.post('/register', registerUser);
router.post('/login', loginUser);
router.post('/reset-password', resetPassword);
router.get('/user/exists', checkPhoneExists);

module.exports = router;
