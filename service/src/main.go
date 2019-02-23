package main

import "github.com/gin-gonic/gin"

func main()  {
	r := gin.Default()

	r.GET("/", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": "I am working",
		})
	})

	r.GET("/hello", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": "Changed hello world!",
		})
	})

	r.Run()
}
