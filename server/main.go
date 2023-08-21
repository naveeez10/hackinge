package main

import (
	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()

	r.POST("/sendotp", SendOTP)
	r.POST("/resendotp/:mobile_number", ResendOTP)
	r.POST("/verifyotp", VerifyOTP)

	r.Run(":8080")
}
