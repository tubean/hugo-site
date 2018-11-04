
---
title: "[Hugo] Hướng dẫn xây dựng blog cá nhân bằng Hugo + Github"
slug: blog-with-hugo
date: 2018-11-04
categories:
- Hugo
- Setup
tags:
- Hugo
- Github
- Blog
keywords:
- Hugo
- Go
- Blog
- Github
- Setup
autoThumbnailImage: true
thumbnailImagePosition: "left"
thumbnailImage: https://res.cloudinary.com/deop9ytsv/image/upload/v1541267744/Hugo-designstyle-friday-m.png
coverImage: https://res.cloudinary.com/deop9ytsv/image/upload/v1541273502/Black_flag.svg.png
metaAlignment: center
---
Bên cạnh các dịch vụ support người dùng tạo các trang blog cá nhân như `blogger`, `wordpress`,... thì các dịch vụ hosting như `github`, `bitbucket`,... cũng đã cho phép chúng ta xây dựng các trang blog trên chính tên miền của họ. Phổ biến hiện nay là các trang miền github.io được xây dựng trên nền tảng `Jekyll`. Tuy nhiên `Jekyll` không phải là duy nhất và cũng có những nhược điểm của riêng nó. Bài viết này tôi sẽ hướng dẫn các bạn xây dựng trang blog cá nhân của riêng mình trên tên miền github.io nhưng dựa trên công nghệ Hugo nina và bọn trẻ :smile:.

# 1. Hugo là ai? À là gì?
Hugo hay Jekyll thì nó cũng là một nền tảng xây dựng website tĩnh, chính xác thì là chúng ta sẽ viết các bài post bằng `markdown (.md)` và các công nghệ này sẽ tự động generate ra các trang html, css theo một template cho trước. `Jekyll` thì được viết bằng `Ruby`, còn `Hugo` được xây dựng trên ngôn ngữ `Go`. Cá nhân mình thấy sử dụng Jekyll thì setup và build trên github nhanh hơn, nhưng mình là mình thích Hugo nina và bọn trẻ nên là mình xây dựng trang blog này trên nền tảng Hugo :sweat_smile:

# 2. Đặt tên miền cho blog

Trước tiên bạn phải chọn cho mình cái tên để đặt cho blog. À nhưng mà bạn không có quyền lựa chọn đâu, vì xây dựng trên miền github.io thì mặc định tên miền trang blog phải tên mẫu `username.github.io`, trong đó `username` chính là tên tài khoản github của bạn. Vì thế nên nếu muốn có cái tên gì hay ho thì tốt nhất là tạo một account github mới mà dùng :grin:
Ok, nếu bạn đã có tài khoản github với một cái tên mĩ miều thì hãy vào tạo một repository mới với cái tên theo mẫu `username.github.io`, trong đó `username` là cái gì thì vừa nói rồi.  :laughing: Mỗi tài khoản github chỉ được tạo duy nhất một trang host như vậy nên muốn tạo nhiều blog thì mạnh dạn đăng ký nhiều tài khoản github nhé  :smile:

# 3. Cài đặt repository

Đối với các trang blog xây dựng bằng `Jekyll` thì có lẽ bạn chỉ cần duy nhất một repository như bước 2 là đủ ( tùy một số theme yêu cầu cài plugin mà github không hỗ trợ thì phải làm hơi khác). Nhưng với trang blog xây dựng bằng `Hugo` thì bạn cần thêm một repository nữa (cái này tên gì cũng được vì không được public ra ngoài).
Như vậy chúng ta sẽ tạo 2 repository với mục đích như sau:
1. `<blog-name>-hugo` (tạm gọi là repo lớn) : mục tiêu cao cả là lưu trữ toàn bộ source code của bạn.
2. `<github username>.github.io` (tạm gọi là repo nhỏ) : nhiệm vụ lưu trữ những thứ được generate ra và host trang blog của bạn.
Tạo xong hai repository thì bạn clone chúng về máy tính, tuy nhiên bạn cần chú ý là đặt repo `github.io` làm submodule của repo lớn, để khi chúng ta update repo nhỏ thì repo lớn tự động update:
```
git clone git@github.com:<username>/<blog-name>-hugo.git
git submodule add git@github.com:<username>/<username>.github.io.git
```

# 4. Chọn theme phù hợp

Giờ là lúc các bạn đi chợ chọn cho mình bộ quần áo đẹp cho trang blog. Hàng free rất nhiều, hàng tính phí cũng đa chủng loại, tất cả đều có ở [đây](https://themes.gohugo.io/).
Các bạn nhớ chọn xong thì xem hướng dẫn sử dụng để biết theme phù hợp với phiên bản Hugo bao nhiêu nhé  :grin:

# 5. Cài đặt Hugo

Như trên [trang chủ](https://gohugo.io/getting-started/quick-start/) của Hugo cũng đã hướng dẫn chi tiết cách cài đặt, tuy nhiên nếu chẳng may gặp vấn đề do version thì chúng ta sẽ không biết cài bản thấp hơn như thế nào đúng không? Vì thế mình khuyên các bạn nên đọc version mà theme support để cài, sau đó thì vào [đây](https://github.com/gohugoio/hugo/releases/) để tìm phiên bản phù hợp.
 Chú ý chọn đúng gói dành cho hệ điều hành bạn đang sử dụng
# 6. Tạo blog cùng chị Hugo Nina
Bật powershell hoặc terminal và trỏ đến folder repo lớn, sau đó gõ lệnh sau:
```
hugo new site quickstart
```
Hugo sẽ tự động tạo các file cần thiết. Việc tiếp theo của chúng ta là thêm template vào giúp nó. Giả sử như bạn sử dụng theme [Ananke](https://themes.gohugo.io/gohugo-theme-ananke/) thì bạn sẽ vào trang theme đó, chọn download -> trình duyệt tự động chuyển đến repository của theme trên github. Copy link http và sửa đoạn code sau theo theme của bạn:
```terminal
 # Tạo submodule trong thư mục themes và đặt tên là ananke
	git submodule add https://github.com/budparr/gohugo-theme-ananke.git 	themes/ananke;\
 # Sửa file config.toml: thêm dòng 'theme = "ananke" để chỉ thư mục ananke chứa theme
	echo  'theme = "ananke"' >> config.toml
```
Mỗi loại theme đều có phần config file `config.toml` cơ bản nằm trong phần `example` của nó. Các bạn nên copy toàn bộ nội dung trong file `config.toml` của nó rồi paste vào file `config.toml` của mình. Nhớ sửa lại dòng `theme= <tên folder chứa theme bạn clone về>`.
# 7. Tạo bài viết đầu tiên
```
#Tạo post mới tên là about.md
hugo new about.md
```
Gõ lệnh trên vào terminal, nhớ là terminal vẫn đang ở thư mục repo lớn. Sau đó vào folder `content` kiểm tra, bạn sẽ thấy file `about.md`. Viết linh tinh gì trong đấy theo ý bạn :wink:
Chạy tiếp lệnh sau:
```
hugo
```
Lúc này bạn kiểm tra bằng lệnh `ls` hoặc dùng editor nào có khả năng nhìn thấy thư mục ẩn thì bạn sẽ phát hiện ra thư mục `public` được tạo, bên trong nó là các file html, css, bla bla... Đây là những file được generate từ project của bạn và bạn cần đẩy nó lên repo nhỏ của mình.
Để nó luôn generate vào thư mục chứa của repo nhỏ thì bạn sẽ vào file `config.toml` của project ( là của project chứ không phải example nhé) và tìm dòng `publishdir` . Nếu không tìm thấy thì bạn thêm dòng này vào trong file `config.toml` (chú ý sửa lại tên cho đúng của bạn, đừng copy vô tội vạ   :smirk:)
```
publishdir = "<github username>.github.io"
```
# 8. Chạy thử trên local
Chạy lệnh sau để pulish lên local
```
hugo server
```
Blog của bạn sẽ được publish tại địa chỉ `http://localhost:1313`.
# 9. Cho mọi thứ lên github
Trước tiên bạn phải kiểm tra lại thư mục `public` còn không, nếu còn thì xóa nó đi và chạy lại lệnh `hugo` để generate lại các file tĩnh vào thư mục chứa repo nhỏ.
Cuối cùng là commit và push hết lên github thôi  :laughing:
Để đơn giản thì bạn chỉ cần chạy lệnh sau, các submodule sẽ tự động cập nhật
```
git push --recurse-submodules=on-demand
```
Cuối cùng, lên trang `http://<github username>.github.io` để nhận hàng  :kissing:
