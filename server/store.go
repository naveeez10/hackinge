package main

import "time"

var otpStore = make(map[string]OTPData)

func StoreOTP(mobileNumber string, otp string) {
	otpStore[mobileNumber] = OTPData{
		MobileNumber: mobileNumber,
		OTP:          otp,
		Timestamp:    time.Now(),
	}
}

func IsValidOTP(mobileNumber string, otp string) bool {
	storedOTP, exists := otpStore[mobileNumber]
	if !exists || storedOTP.OTP != otp {
		return false
	}

	// Optional: Check OTP expiry
	if time.Since(storedOTP.Timestamp).Minutes() > 5 {
		return false
	}

	return true
}
