package main

import (
	"fmt"
	"log"
	"math/rand"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/twilio/twilio-go"
	openapi "github.com/twilio/twilio-go/rest/verify/v2"
)

type OTPData struct {
	MobileNumber string `json:"mobile_number"`
	OTP          string
	Timestamp    time.Time
}

func generateOTP() string {
	return fmt.Sprintf("%06d", rand.Intn(999999))
}

const (
	AccountSid   = "ACd28c608f24912de48b5c1238a48a737d"
	AuthToken    = "f88d8d8ae3b21b3383f63193d194aa00"
	TwilioNumber = "+17622149713"
)

func sendOTPWithTwilio(mobileNumber string, otp string) error {
	var client *twilio.RestClient = twilio.NewRestClientWithParams(twilio.ClientParams{
		Username: AccountSid,
		Password: AuthToken,
	})

	params := &openapi.CreateVerificationParams{}
	params.SetTo(*params.To)
	params.SetChannel("sms")

	resp, err := client.VerifyV2.CreateVerification(VERIFY_SERVICE_SID, params)

	if err != nil {
		fmt.Println(err.Error())
	} else {
		fmt.Printf("Sent verification '%s'\n", *resp.Sid)
	}

	log.Printf("Message sent: %s", message.Sid)
	return nil
}

func SendOTP(c *gin.Context) {
	var requestData OTPData
	if err := c.BindJSON(&requestData); err != nil {
		c.JSON(400, gin.H{"error": err.Error()})
		return
	}

	otp := generateOTP()
	sendOTPWithTwilio(requestData.MobileNumber, otp)
	StoreOTP(requestData.MobileNumber, otp)
	c.JSON(200, gin.H{"message": "OTP sent"})
}

func ResendOTP(c *gin.Context) {
	mobileNumber := c.Param("mobile_number")
	otp := generateOTP()
	sendOTPWithTwilio(mobileNumber, otp)
	StoreOTP(mobileNumber, otp)
	c.JSON(200, gin.H{"message": "OTP resent"})
}

func VerifyOTP(c *gin.Context) {
	var requestData OTPData
	if err := c.BindJSON(&requestData); err != nil {
		c.JSON(400, gin.H{"error": err.Error()})
		return
	}

	if !IsValidOTP(requestData.MobileNumber, requestData.OTP) {
		c.JSON(400, gin.H{"error": "Invalid OTP"})
		return
	}

	c.JSON(200, gin.H{"message": "OTP verified"})
}
