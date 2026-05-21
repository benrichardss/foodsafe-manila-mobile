const bcrypt = require('bcryptjs');
const User = require('../models/userModel');

function normalizePhone(phone) {
  return String(phone).replaceAll(' ', '');
}

function sanitizeUser(user) {
  const userJson = user.toObject();
  delete userJson.password;
  return userJson;
}

async function registerUser(req, res) {
  const { username, phone, password, email } = req.body;

  if (!username || !phone || !password) {
    return res.status(400).json({ message: 'Missing required fields' });
  }

  try {
    const normalizedPhone = normalizePhone(phone);
    const existingUser = await User.findOne({ phone_number: normalizedPhone });

    if (existingUser) {
      return res.status(409).json({ message: 'Phone number already registered' });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const user = await User.create({
      username,
      phone_number: normalizedPhone,
      password: hashedPassword,
      email: email ?? '',
    });

    res.status(201).json(sanitizeUser(user));
  } catch (error) {
    console.error('Register error', error);
    res.status(500).json({ message: 'Failed to register user' });
  }
}

async function loginUser(req, res) {
  const { phone, password } = req.body;

  if (!phone || !password) {
    return res.status(400).json({ message: 'Missing required fields' });
  }

  try {
    const normalizedPhone = normalizePhone(phone);
    const user = await User.findOne({ phone_number: normalizedPhone });

    if (!user) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch && user.password !== password) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }

    res.json(sanitizeUser(user));
  } catch (error) {
    console.error('Login error', error);
    res.status(500).json({ message: 'Failed to login' });
  }
}

async function resetPassword(req, res) {
  const { phone, newPassword } = req.body;

  if (!phone || !newPassword) {
    return res.status(400).json({ message: 'Missing required fields' });
  }

  try {
    const normalizedPhone = normalizePhone(phone);
    const user = await User.findOne({ phone_number: normalizedPhone });

    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    const hashedPassword = await bcrypt.hash(newPassword, 10);
    user.password = hashedPassword;
    await user.save();

    res.json({ success: true });
  } catch (error) {
    console.error('Reset password error', error);
    res.status(500).json({ message: 'Failed to reset password' });
  }
}

async function checkPhoneExists(req, res) {
  const phone = req.query.phone;
  if (!phone) {
    return res.status(400).json({ message: 'Phone query is required' });
  }

  try {
    const normalizedPhone = normalizePhone(phone);
    const exists = await User.exists({ phone_number: normalizedPhone });
    res.json({ exists: Boolean(exists) });
  } catch (error) {
    console.error('User exists error', error);
    res.status(500).json({ message: 'Failed to check phone number' });
  }
}

module.exports = {
  registerUser,
  loginUser,
  resetPassword,
  checkPhoneExists,
};
