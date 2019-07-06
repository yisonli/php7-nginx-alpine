## 生成镜像
`docker build -t yisonli/php7-nginx-alpine:1.3 .`


## 运行镜像
`docker run -d -p 8080:8080 yisonli/php7-nginx-alpine:1.3`

【supervisor版】  
`docker run -d -p 8080:8080 yisonli/php7-nginx-alpine:1.3.S`

