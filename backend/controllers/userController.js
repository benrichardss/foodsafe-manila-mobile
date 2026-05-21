const User = require('../models/userModel');

function normalizePhone(phone) {
  return String(phone).replaceAll(' ', '');
}

function sanitizeUser(user) {
  const userJson = user.toObject();
  delete userJson.password;
  return userJson;
}

async function updateUser(req, res) {
  const { id } = req.params;
  const { username, phone, email } = req.body;

  if (!username || !phone) {
    return res.status(400).json({ message: 'Missing required fields' });
  }

  try {
    const normalizedPhone = normalizePhone(phone);
    const existingPhoneUser = await User.findOne({ phone_number: normalizedPhone, _id: { $ne: id } });
    if (existingPhoneUser) {
      return res.status(409).json({ message: 'Phone number already in use' });
    }

    const user = await User.findById(id);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    user.username = username;
    user.phone_number = normalizedPhone;
    user.email = email ?? '';
    await user.save();

    res.json(sanitizeUser(user));
  } catch (error) {
    console.error('Update user error', error);
    res.status(500).json({ message: 'Failed to update user' });
  }
}

module.exports = {
  updateUser,
};
