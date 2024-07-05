-- Drop tables if they exist to ensure a clean slate
DROP TABLE IF EXISTS `recipe_likes`;
DROP TABLE IF EXISTS `recipe_comment`;
DROP TABLE IF EXISTS `recipe_photos`;
DROP TABLE IF EXISTS `orders`;
DROP TABLE IF EXISTS `cart`;
DROP TABLE IF EXISTS `user_review`;
DROP TABLE IF EXISTS `diet_calendar_record`;
DROP TABLE IF EXISTS `meal_exchanges_comment`;
DROP TABLE IF EXISTS `meal_exchanges`;
DROP TABLE IF EXISTS `best_recipe_user_review`;
DROP TABLE IF EXISTS `best_recipe_mealkit`;
DROP TABLE IF EXISTS `recipe`;
DROP TABLE IF EXISTS `mealkit`;
DROP TABLE IF EXISTS `admin`;
DROP TABLE IF EXISTS `member`;

-- 테이블 생성 
CREATE TABLE `member` (
    `user_id` bigint(20) NOT NULL AUTO_INCREMENT,
    `user_name` VARCHAR(255) NOT NULL,
    `user_age` VARCHAR(255) NOT NULL,
    `user_address` VARCHAR(255) NOT NULL,
    `user_nickname` VARCHAR(255) NOT NULL,
    `user_gender` VARCHAR(255) NOT NULL,
    `user_solo_years` VARCHAR(255) NOT NULL,
    `user_email` VARCHAR(255) NOT NULL,
    `user_password` VARCHAR(255) NOT NULL,
    `user_created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `user_deleted_at` timestamp NULL,
    `user_status` VARCHAR(255) NOT NULL DEFAULT '활성',
    CHECK(user_status IN ('활성','비활성')),
    PRIMARY KEY (`user_id`)
) ENGINE=INNODB AUTO_INCREMENT=1 COMMENT='회원';

CREATE TABLE `admin` (
    `admin_id` bigint(20) NOT NULL AUTO_INCREMENT,
    `company_number` VARCHAR(255) NOT NULL,
    `admin_password` VARCHAR(255) NOT NULL,
    `admin_name` VARCHAR(255) NOT NULL,
    `admin_service_years` int NOT NULL,
    `admin_created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `admin_created_atd` timestamp NULL,
    `admin_status` VARCHAR(255) NOT NULL DEFAULT '활성',
     CHECK(admin_status IN ('활성','비활성')),
    PRIMARY KEY (`admin_id`)
) ENGINE=INNODB AUTO_INCREMENT=1 COMMENT='관리자';

CREATE TABLE `mealkit` (
    `mealkit_id` bigint(20) NOT NULL AUTO_INCREMENT,
    `mealkit_name` VARCHAR(255) NOT NULL,
    `mealkit_photo` TEXT NOT NULL,
    `mealkit_price` int NOT NULL,
    `mealkit_ingredient` VARCHAR(255) NOT NULL,
    `mealkit_calories` int NOT NULL,
    `mealkit_order_count` int NOT NULL,
    `mealkit_stock` int NOT NULL,
    `mealkit_created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `mealkit_updated_at` timestamp NULL,
    `mealkit_deleted_at` timestamp NULL,
    `admin_id` bigint(20) NOT NULL,
    `mealkit_status` VARCHAR(255) NOT NULL CHECK(mealkit_status IN ('판매중','품절','수정','삭제')),
    PRIMARY KEY (`mealkit_id`),
    FOREIGN KEY (`admin_id`) REFERENCES `admin`(`admin_id`) ON DELETE CASCADE
) ENGINE=INNODB AUTO_INCREMENT=1 COMMENT='밀키트';

CREATE TABLE `recipe` (
    `recipe_id` bigint(20) NOT NULL AUTO_INCREMENT,
    `recipe_name` VARCHAR(255) NOT NULL,
    `recipe_created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `recipe_update_at` timestamp NULL,
    `recipe_ingredient` VARCHAR(255) NOT NULL,
    `recipe_describe` VARCHAR(255) NOT NULL,
    `recipe_calories` int NULL,
    `recipe_cooking_time` VARCHAR(255) NOT NULL,
    `recipe_servings` VARCHAR(255) NOT NULL,
    `recipe_difficulty` VARCHAR(255) NOT NULL CHECK(recipe_difficulty IN ('상','중','하')),
    `recipe_likes_count` int NOT NULL DEFAULT 0,
    `user_id` bigint(20) NOT NULL,
    PRIMARY KEY (`recipe_id`),
    FOREIGN KEY (`user_id`) REFERENCES `member`(`user_id`) ON DELETE CASCADE
) ENGINE=INNODB AUTO_INCREMENT=1 COMMENT='레시피';

CREATE TABLE `best_recipe_mealkit` (
    `best_mealkit_id` bigint(20) NOT NULL AUTO_INCREMENT,
    `best_mealkit_name` VARCHAR(255) NOT NULL,
    `best_mealkit_photo` TEXT NOT NULL,
    `best_mealkit_price` int NOT NULL,
    `best_mealkit_ingredient` VARCHAR(255) NOT NULL,
    `best_mealkit_calories` int NOT NULL,
    `best_mealkit_order_count` int NOT NULL,
    `best_mealkit_stock` int NOT NULL,
    `best_mealkit_created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `best_mealkit_updated_at` timestamp NULL,
    `best_mealkit_deleted_at` timestamp NULL,
    `best_author` VARCHAR(255) NOT NULL,
    `best_selected_time` timestamp NOT NULL,
    `best_mealkit_status` VARCHAR(255) NOT NULL CHECK(best_mealkit_status IN ('판매중','품절','수정','삭제')),
    `admin_id` bigint(20) NOT NULL,
    PRIMARY KEY (`best_mealkit_id`),
    FOREIGN KEY (`admin_id`) REFERENCES `admin`(`admin_id`) ON DELETE CASCADE
) ENGINE=INNODB AUTO_INCREMENT=1 COMMENT='베스트 레시피 밀키트';

CREATE TABLE `recipe_likes` (
    `like_id` bigint(20) NOT NULL AUTO_INCREMENT,
    `recipe_id` bigint(20) NOT NULL,
    `like_created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `user_id` bigint(20) NOT NULL,
    PRIMARY KEY (`like_id`, `recipe_id`),
    FOREIGN KEY (`recipe_id`) REFERENCES `recipe`(`recipe_id`) ON DELETE CASCADE,
    FOREIGN KEY (`user_id`) REFERENCES `member`(`user_id`) ON DELETE CASCADE
) ENGINE=INNODB AUTO_INCREMENT=1 COMMENT='레시피 좋아요';

CREATE TABLE `cart` (
    `cart_id` bigint(20) NOT NULL AUTO_INCREMENT,
    `mealkit_order_count` INT NOT NULL,
    `best_mealkit_order_count` int NOT NULL,
    `mealkit_id` bigint(20) NULL,
    `best_mealkit_id` bigint(20) NULL,
    `user_id` bigint(20) NOT NULL,
    `cart_status` VARCHAR(255) NOT NULL CHECK(cart_status IN ('주문전','주문','주문취소')),
    PRIMARY KEY (`cart_id`),
    FOREIGN KEY (`mealkit_id`) REFERENCES `mealkit`(`mealkit_id`) ON DELETE CASCADE,
    FOREIGN KEY (`best_mealkit_id`) REFERENCES `best_recipe_mealkit`(`best_mealkit_id`) ON DELETE CASCADE,
    FOREIGN KEY (`user_id`) REFERENCES `member`(`user_id`) ON DELETE CASCADE
) ENGINE=INNODB AUTO_INCREMENT=1 COMMENT='장바구니';

CREATE TABLE `orders` (
    `order_id` bigint(20) NOT NULL AUTO_INCREMENT,
    `order_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `order_status` VARCHAR(255) NOT NULL CHECK(order_status IN ('주문','주문취소')),
    `order_cancel_at` timestamp NULL,
    `cart_id` bigint(20) NOT NULL,
    PRIMARY KEY (`order_id`),
    FOREIGN KEY (`cart_id`) REFERENCES `cart`(`cart_id`) ON DELETE CASCADE
) ENGINE=INNODB AUTO_INCREMENT=1 COMMENT='주문';

CREATE TABLE `recipe_comment` (
    `recipe_comment_id` bigint(20) NOT NULL AUTO_INCREMENT,
    `recipe_id` bigint(20) NOT NULL,
    `recipe_comment_content` VARCHAR(255) NOT NULL,
    `recipe_comment_created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `recipe_comment_updated_at` timestamp NULL,
    `user_id` bigint(20) NOT NULL,
    PRIMARY KEY (`recipe_comment_id`, `recipe_id`),
    FOREIGN KEY (`recipe_id`) REFERENCES `recipe`(`recipe_id`) ON DELETE CASCADE,
    FOREIGN KEY (`user_id`) REFERENCES `member`(`user_id`) ON DELETE CASCADE
) ENGINE=INNODB AUTO_INCREMENT=1 COMMENT='레시피 댓글';

CREATE TABLE `diet_calendar_record` (
    `diet_calendar_record_id` bigint(20) NOT NULL AUTO_INCREMENT,
    `diet_name` VARCHAR(255) NOT NULL,
    `diet_time` timestamp NOT NULL,
    `diet_photo` TEXT NOT NULL,
    `diet_calories` int NULL,
    `user_id` bigint(20) NOT NULL,
    PRIMARY KEY (`diet_calendar_record_id`),
    FOREIGN KEY (`user_id`) REFERENCES `member`(`user_id`) ON DELETE CASCADE
) ENGINE=INNODB AUTO_INCREMENT=1 COMMENT='식단 기록';

CREATE TABLE `meal_exchanges` (
    `meal_exchanges_id` bigint(20) NOT NULL AUTO_INCREMENT,
    `meal_exchanges_title` VARCHAR(255) NOT NULL,
    `meal_exchanges_content` VARCHAR(255) NOT NULL,
    `meal_exchanges_created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `meal_exchanges_delete_at` timestamp NULL,
    `user_id` bigint(20) NOT NULL,
    PRIMARY KEY (`meal_exchanges_id`),
    FOREIGN KEY (`user_id`) REFERENCES `member`(`user_id`) ON DELETE CASCADE
) ENGINE=INNODB AUTO_INCREMENT=1 COMMENT='식재료 게시글';

CREATE TABLE `recipe_photos` (
    `photos_id` bigint(20) NOT NULL AUTO_INCREMENT,
    `recipe_id` bigint(20) NOT NULL,
    `recipe_photo` TEXT NOT NULL,
    PRIMARY KEY (`photos_id`, `recipe_id`),
    FOREIGN KEY (`recipe_id`) REFERENCES `recipe`(`recipe_id`) ON DELETE CASCADE
) ENGINE=INNODB AUTO_INCREMENT=1 COMMENT='레시피 사진';

CREATE TABLE `user_review` (
    `review_id` bigint(20) NOT NULL AUTO_INCREMENT,
    `review_content` VARCHAR(255) NOT NULL,
    `review_created_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `review_updated_at` timestamp NULL,
    `review_scope` int NOT NULL,
    `mealkit_id` bigint(20) NOT NULL,
    `user_id` bigint(20) NOT NULL,
    PRIMARY KEY (`review_id`),
    FOREIGN KEY (`mealkit_id`) REFERENCES `mealkit`(`mealkit_id`) ON DELETE CASCADE,
    FOREIGN KEY (`user_id`) REFERENCES `member`(`user_id`) ON DELETE CASCADE
) ENGINE=INNODB AUTO_INCREMENT=1 COMMENT='밀키트 사용자 리뷰';

CREATE TABLE `best_recipe_user_review` (
    `review_id` bigint(20) NOT NULL AUTO_INCREMENT,
    `review_content` VARCHAR(255) NOT NULL,
    `review_created_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `review_updated_at` timestamp NULL,
    `review_scope` int NOT NULL,
    `user_id` bigint(20) NOT NULL,
    `best_mealkit_id` bigint(20) NOT NULL,
    PRIMARY KEY (`review_id`),
    FOREIGN KEY (`user_id`) REFERENCES `member`(`user_id`) ON DELETE CASCADE,
    FOREIGN KEY (`best_mealkit_id`) REFERENCES `best_recipe_mealkit`(`best_mealkit_id`) ON DELETE CASCADE
) ENGINE=INNODB AUTO_INCREMENT=1 COMMENT='베스트 레시피 밀키트 사용자 리뷰'; 

CREATE TABLE `meal_exchanges_comment` (
    `meal_comment_id` bigint(20) NOT NULL AUTO_INCREMENT,
    `meal_exchanges_id` bigint(20) NOT NULL,
    `meal_comment_content` VARCHAR(255) NOT NULL,
    `meal_comment_created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `meal_comment_updated_at` timestamp NULL,
    PRIMARY KEY (`meal_comment_id`, `meal_exchanges_id`),
    FOREIGN KEY (`meal_exchanges_id`) REFERENCES `meal_exchanges`(`meal_exchanges_id`) ON DELETE CASCADE
) ENGINE=INNODB AUTO_INCREMENT=1 COMMENT='식재료 게시글 댓글' ;


-- 회원 데이터
INSERT 
  INTO member 
(
  `user_id`,`user_name`,`user_age`,
  `user_address`,`user_nickname`,`user_gender`,
  `user_solo_years`,`user_email`,`user_password`,
  `user_created_at`,`user_deleted_at`,`user_status`
)
VALUES 
(NULL, '김철수', 25, '서울특별시 강남구', 'chulsoo', '남', 2, 'chulsoo@example.com', 'password1', '2022-01-01 10:00:00', '2024-01-01 10:00:00', '비활성'),
(NULL, '이영희', 30, '경기도 성남시', 'younghee', '여', 5, 'younghee@example.com', 'password2', '2021-05-15 14:30:00', NULL, '활성'),
(NULL, '박민수', 28, '부산광역시 해운대구', 'minsoo', '남', 3, 'minsoo@example.com', 'password3', '2023-03-22 9:45:00', NULL, '활성'),
(NULL, '김지수', 22, '대구광역시 북구', 'jisu', '여', 1, 'jisu@example.com', 'password4', '2022-09-12 8:20:00', NULL, '활성'),
(NULL, '이준호', 35, '서울특별시 서초구', 'junho', '남', 7, 'junho@example.com', 'password5', '2018-07-03 12:00:00', '2023-01-03 12:00:00', '비활성'),
(NULL, '박세진', 27, '인천광역시 남구', 'sejin', '여', 2, 'sejin@example.com', 'password6', '2023-05-10 15:45:00', NULL, '활성'),
(NULL, '최수연', 24, '경기도 수원시', 'suyeon', '여', 1, 'suyeon@example.com', 'password7', '2022-08-08 10:00:00', NULL, '활성'),
(NULL, '정한결', 26, '경기도 용인시', 'hangyeol', '남', 3, 'hangyeol@example.com', 'password8', '2021-11-11 14:30:00', NULL, '활성'),
(NULL, '조민정', 29, '서울특별시 마포구', 'minjung', '여', 4, 'minjung@example.com', 'password9', '2019-10-25 11:00:00', NULL, '활성'),
(NULL, '황민호', 31, '광주광역시 서구', 'minho', '남', 6, 'minho@example.com', 'password10', '2017-06-20 13:00:00', NULL, '활성'),
(NULL, '강다희', 23, '대전광역시 중구', 'dahee', '여', 1, 'dahee@example.com', 'password11', '2023-01-01 09:00:00', NULL, '활성'),
(NULL, '문지영', 32, '울산광역시 남구', 'jiyoung', '여', 8, 'jiyoung@example.com', 'password12', '2016-04-15 10:30:00', NULL, '활성'),
(NULL, '송현우', 34, '서울특별시 은평구', 'hyunwoo', '남', 9, 'hyunwoo@example.com', 'password13', '2015-12-01 08:45:00', NULL, '활성'),
(NULL, '윤아름', 28, '부산광역시 사하구', 'areum', '여', 4, 'areum@example.com', 'password14', '2019-03-03 10:10:00', NULL, '활성'),
(NULL, '임동훈', 25, '경기도 고양시', 'donghoon', '남', 2, 'donghoon@example.com', 'password15', '2022-07-07 14:20:00', NULL, '활성'),
(NULL, '오지혜', 27, '인천광역시 미추홀구', 'jihye', '여', 3, 'jihye@example.com', 'password16', '2021-10-10 12:00:00', NULL, '활성'),
(NULL, '서현진', 29, '경기도 부천시', 'hyunjin', '여', 4, 'hyunjin@example.com', 'password17', '2019-08-08 09:30:00', NULL, '활성'),
(NULL, '신동민', 24, '대구광역시 동구', 'dongmin', '남', 1, 'dongmin@example.com', 'password18', '2023-04-04 11:45:00', NULL, '활성'),
(NULL, '조현우', 31, '부산광역시 연제구', 'hyunwooj', '남', 7, 'hyunwooj@example.com', 'password19', '2018-09-09 14:15:00', NULL, '활성'),
(NULL, '구민정', 30, '서울특별시 강서구', 'minjungku', '여', 6, 'minjungku@example.com', 'password20', '2017-03-03 12:40:00', NULL, '활성'),
(NULL, '장준혁', 26, '인천광역시 계양구', 'junhyuk', '남', 3, 'junhyuk@example.com', 'password21', '2021-05-05 08:00:00', NULL, '활성'),
(NULL, '백서연', 22, '경기도 안양시', 'seoyeon', '여', 1, 'seoyeon@example.com', 'password22', '2023-07-07 13:50:00', NULL, '활성'),
(NULL, '홍진수', 27, '서울특별시 종로구', 'jiinsuk', '남', 4, 'jiinsuk@example.com', 'password23', '2019-12-12 10:00:00', NULL, '활성'),
(NULL, '임예슬', 33, '대전광역시 서구', 'yesle', '여', 9, 'yesle@example.com', 'password24', '2015-02-02 09:00:00', NULL, '활성'),
(NULL, '안민혁', 35, '서울특별시 용산구', 'minhyeok', '남', 10, 'minhyeok@example.com', 'password25', '2014-01-01 10:00:00', NULL, '활성'),
(NULL, '진세영', 23, '대구광역시 수성구', 'seyoung', '여', 1, 'seyoung@example.com', 'password26', '2023-06-06 14:45:00', NULL, '활성'),
(NULL, '차민주', 28, '서울특별시 관악구', 'minjoo', '여', 5, 'minjoo@example.com', 'password27', '2018-08-08 13:30:00', NULL, '활성'),
(NULL, '황지성', 31, '경기도 성남시 분당구', 'jisung', '남', 7, 'jisung@example.com', 'password28', '2017-10-10 10:10:00', NULL, '활성'),
(NULL, '백주희', 24, '부산광역시 북구', 'juhui', '여', 2, 'juhui@example.com', 'password29', '2022-05-05 08:50:00', NULL, '활성'),
(NULL, '현지호', 29, '인천광역시 연수구', 'jiho', '남', 5, 'jiho@example.com', 'password30', '2018-12-12 09:30:00', NULL, '활성');


-- 관리자 데이터
INSERT 
  INTO admin 
(
  `admin_id`,`company_number`,`admin_password`,
  `admin_name`,`admin_service_years`,`admin_created_at`,
  `admin_created_atd`,`admin_status`
)
VALUES 
(NULL, 1001, 'admin1', '김관리', 3, '2021-06-01', NULL, '활성'),
(NULL, 1002, 'admin2', '송관리', 7, '2017-02-15', NULL, '활성'),
(NULL, 1003, 'admin3', '유관리', 2, '2022-08-20', NULL, '활성'),
(NULL, 1004, 'admin4', '이관리', 4, '2020-11-30', '2023-06-30', '비활성'),
(NULL, 1005, 'admin5', '조관리', 1, '2023-01-10', NULL, '활성');


-- 공구 게시글
INSERT 
  INTO meal_exchanges
(
  meal_exchanges_id,
  meal_exchanges_title, 
  meal_exchanges_content, 
  meal_exchanges_created_at, 
  meal_exchanges_delete_at, 
  user_id
)
VALUES
(NULL, '[공구] 신선한 무농약 채소 함께 구매해요!', '안녕하세요,\n무농약 채소를 저렴하게 구매할 수 있는 기회를 찾았어요.\n하지만 최소 주문량이 많아서 함께 공구하실 분을 찾습니다.\n양상추, 시금치, 당근 등을 포함한 패키지입니다.\n관심 있으신 분들은 댓글이나 쪽지 부탁드려요.\n배송비는 인원수에 따라 나눌 예정입니다. 감사합니다!', '2024-06-01 12:11:00', NULL, 2),
(NULL, '[공구] 양파 5kg', '양파 5kg 저렴하게 공동구매해요. 함께 하실 분 모집합니다.', '2024-06-01 12:11:00', NULL, 9),
(NULL, '[공구] 한우 1+ 등급 정육 공구 진행합니다', '한우 진짜 좋은 1+ 등급 정육 저렴하게 구입 가능해여!!! 최소 주문 수량때문에 공구 진행합니당!!! 배송비는  나눠서 부담해여 많은 참여 부탁드려여....', '2024-06-04 09:45:00', '2024-06-04 09:48:00', 10),
(NULL, '[공구] 대파 3kg', '대파가 진짜 싱싱 그자체 ㅋㅋ 미쳤음 ㄹㅇ 말안됨 가질사람?', '2024-06-04 09:45:00', NULL, 22),
(NULL, '[교환] 베이킹 재료 교환 하실분?', '집에 강력분 밀가루랑 코코아 파우더 있으신분계신가요 설탕이랑 바닐라 에센스 드릴게요 그냥 가격 생각 안하고 교환 하실분만 댓달아주세요 찔러보기 ㄴ', '2024-06-07 14:30:00', NULL, 21),
(NULL, '[공구] 닭가슴살 1kg', '닭찌찌 너무 많이사서 냉동고에 다 안들어가요.. 길냥이 줄빠에 공구합니다. 뽀빠이 되실분? 딥 ㅂㅌ', '2024-06-07 14:37:00', NULL, 2),
(NULL, '[교환] (나) 사과 (님) 딸기 교환하실분제발', '선물받아서 사과만 한달째 먹고있어요 그만먹고싶어요 딸기 아니어도 되니까 교환하실분 제발 아니면 사과만 받아가시던가요', '2024-06-10 11:22:00', NULL, 18),
(NULL, '[교환] 고구마 -> 아무거나', '고구마랑 아무거나랑 교환해용', '2024-06-10 11:29:00', NULL, 30),
(NULL, '[공구] 토마토가 먹고싶다면? 드루와', '토마토 탕후루 만들다가 개망함 ... ㅜㅜ 탕후루 아니면 토마토 안먹어서 나눔 합니다 . 댓글달아 주세요 !!', '2024-06-13 16:00:00', NULL, 17),
(NULL, '[공구] 저희 어머니 밭에서 자란 고추로 빻은 고춧가루입니다', '업체 거치지 않고 직접 가져오는거라 싸게 구매 가능합니다 댓달아주셔요', '2024-06-13 16:08:50', NULL, 5),
(NULL, '[교환] 계란이랑 슬라이스 치즈 교환 하실분', '재료 다있는줄알고 토스트했는데 치즈가 없어요 제발 교환실분 ㅠ', '2024-06-15 10:10:00', '2024-06-15 10:30:00', 11),
(NULL, '[교환] 바나나 2다발', '저 지금 원숭이 되기 직전이에요 . 몇일전에 바나나가 너무 먹고싶어서 한박스 시켰는데 10다발이 왔네요 .. ㅋㅋ 공짜는 에바고 교환물 제시해주세요', '2024-06-15 10:20:00', NULL, 28),
(NULL, '[공구] 프리미엄 파스타 소스 6명 할인 판매!', '안녕하세요~ 저 오랜만에 왔죠 ㅠ 기다리신 여러분들을 위해 오늘은 특별히!!  프리미엄 파스타 소스 6병을 할인된 가격 30000원에 판매합니다 >0< 소스는 진짜 맛있어요 파스타 잘알인 제가 보장합니다!! 댓 고고링~!', '2024-06-18 13:25:00', NULL, 24),
(NULL, '[공구] 고시히카리 공구해요', '지금 포털에 검색하시면 최저가 26820원으로 뜨는거 아시죠 저희 공구 이용하시면 10kg 23000원에 구매 가능해요 빨리 선점하세요 수량은 10개 뿐입니다', '2024-06-18 13:28:00', NULL, 14),
(NULL, '[교환] 수제잼이랑 교환할거 있으신분 ㅎㅎ', '어제 블루배리 잼 만들었어용 너무 맛있는데 같이 나누고 싶어요 혹시 간단한거라도 저랑 교환할거 있으신분 댓 긔긔', '2024-06-21 08:30:00', NULL, 13),
(NULL, '[공구] 수박 1통', '씨없는 수박이래서 2통이나 시켰는데 씨가 있네요 그것도 많이.. 기분이 안좋아요 저는 ;; 이 수박 한통의 씨의 유무는 랜덤이에요 보장못합니다. 드실분?', '2024-06-21 08:30:00', NULL, 27),
(NULL, '[공구] 유기농 오렌지 주스 100ml X 20팩', '20000원에 모십니다.', '2024-06-24 15:30:00', NULL, 20),
(NULL, '[교환] 피스타치오 필요하신분', '두바이 초콜릿 만들겠다고 대량으로 사서 엄청 남았어요 과자 몇봉지랑 교환해주실분 이거 비싼거 아시죠?', '2024-06-24 16:30:00', '2024-06-24 16:33:00', 10),
(NULL, '[교환] 김 30장', '김 30장 필요하신 분? 다른 반찬이나 간식과 교환 원해요.', '2024-06-27 10:15:00', NULL, 9),
(NULL, '[교환] 콘푸레이크 500g', '콘푸레이크 500g 있어요. 다른 아침식사 대용품과 교환 원해요.', '2024-06-27 10:15:00', NULL, 5),
(NULL, '[공구] 우유 200ml', '우유 싼가격에 공구해요', '2024-06-30 12:00:00', NULL, 15),
(NULL, '[교환] 울 할매표 깍두기', '할머니가 직접 담근 깍두기 1kg! 어머니 손맛이 그리우신 분들? 다른 반찬과 교환 원해요.', '2024-07-01 08:45:00', NULL, 18),
(NULL, '[교환] 초코우유 -> 커피우유', '힝 어제 친구가 사다줬는데 저 초코 싫어해요 ㅠㅠ 커피우유맛으로 교환해여', '2024-07-01 08:45:00', NULL, 27),
(NULL, '[교환] 유기농 꿀 ( 벌도 안에 좀있어요..)', '직접 벌에 쏘이면서 채취한 유기농 꿀 500g 있어요. 달콤한 맛 원하시면 신청해 주세요~ 다른 식품과 교환해요.', '2024-07-01 09:00:00', NULL, 29),
(NULL, '[공구] 새콤달콤 30개입 한박스', '새콤달콤이 땡기는 날 있으셨죠? 하나 먹자니 아쉽고~ ㅠ 여러개 사자니 힘들구~ ㅠ 같이 공구해서 배달받아 머거요', '2024-07-01 11:12:14', NULL, 11),
(NULL, '[공구] 야매 피클 1병', '제가 직접 만든 야매 피클 1병! 새콤달콤한 맛 완전보장해요. 하지만 입맛은 다 다른법 ㅋㅋ 맛없을 시, 선처 부탁드립니다.....헤헤', '2024-07-01 13:01:30', NULL, 21),
(NULL, '[교환] 감자볶음 했는데 반찬 교환실분', '가지, 김치 빼고 아무거나 다괜찮아요', '2024-07-02 05:00:00', NULL, 6),
(NULL, '[공구] 먹어본 사람은 다 놀라 뒤집어진다는 환상적인 카레!!!!', '이 카레로 말씀드릴거같으면, 아무나 먹지 못하는 귀한 카레입니다. 제가 이거 먹어보고 깜~~~짝 놀라서 이틀동안 못일어났어요. 공구합니다.', '2024-07-02 07:00:00', '2024-07-02 08:00:00', 13),
(NULL, '[교환] 트러플 오일 100ml', '짜파게티에 뿌려먹으면 진짜.. 야무지는거 다들 아시죠 ?  파김치랑 교환하고싶어요 헤헤', '2024-07-02 08:40:00', NULL, 23),
(NULL, '[교환] 시금치랑 파프리카 교환해요', '저 시금치 님 파프리카 개수 동일하게 ㄱㄱ', '2024-07-02 09:00:00', NULL, 12);


-- 공구 게시글 댓글
INSERT 
  INTO meal_exchanges_comment 
(
  meal_comment_id,
  meal_exchanges_id, 
  meal_comment_content,
  meal_comment_created_at,
  meal_comment_updated_at
)
VALUES 
(NULL, 1, '오 패키지예요? 일단 줄서봅니다', '2024-06-01 12:19:00', NULL),
(NULL, 2, '양파를 누가 5키로나 사여...는 제가 삽니다', '2024-06-01 12:35:00', NULL),
(NULL, 3, '1등급이여?! 대박사건 저요!!!', '2024-06-04 10:10:00', NULL),
(NULL, 4, 'ㅋㅋㅋ가질사람이면 사주시는건가요 조크조크 저 줄서용', '2024-06-04 09:49:00', NULL),
(NULL, 5, '밀가루는 없는데 코코아 가루는 있긴해요 그냥 드릴까요? 어차피 안쓰는거라', '2024-06-07 14:38:00', NULL),
(NULL, 6, '내가바로 2024 뽀빠이다', '2024-06-07 15:03:00', NULL),
(NULL, 7, '딸기랑 교환해용 ㅎㅎ 사과 1개당 딸기 2알 어때요', '2024-06-10 12:00:00', NULL),
(NULL, 8, '혹시 감자도 괜찮으세요?', '2024-06-10 11:41:00', NULL),
(NULL, 9, '토마토 어디거예요? 상태 확인해보고 구매하고싶긴하네요...ㅠㅠㅠ', '2024-06-13 16:04:00', NULL),
(NULL, 10, '와.. 때깔 좋겠다... 저요 !! 입자는 고울까요?', '2024-06-13 16:10:01', NULL),
(NULL, 11, '와 치즈 앙팡밖에 없는데.. 괜춘..?', '2024-06-15 10:17:00', NULL),
(NULL, 12, '헉 진짜 원숭이시겠네요;; 원숭이가 다른 과일도 잘먹는거 아세요? 사과랑 교환합시다요 ㅎㅎ', '2024-06-15 10:24:00', NULL),
(NULL, 13, '이집은 믿고봄 ㄹㅇ 다들 얼른 챙기세요 저요 저', '2024-06-18 13:29:00', NULL),
(NULL, 14, '일단 저요. 근데 일반 쌀도 아닌데 10개나 구매하셨어요? 초밥집 하시나', '2024-06-18 13:28:30', NULL),
(NULL, 15, '당도는 어떻게 되나요?', '2024-06-21 08:35:00', NULL),
(NULL, 16, '저 탕후루 만들다가 남은 샤인머스켓 한다발있는데 이건 어때여ㅕ?', '2024-06-21 08:40:00', NULL),
(NULL, 17, '18000원 어때요.', '2024-06-24 15:50:00', NULL),
(NULL, 18, '뒤늦게 유행 따라가야겠네요 저 과자 4봉지 들고갈게요!!', '2024-06-24 16:50:00', NULL),
(NULL, 19, 'ㅋㅋㅋㅋ30장이라고 정해진게 웃겨용 김치볶은거 있는데 어때용', '2024-06-27 11:15:00', NULL),
(NULL, 20, '코코볼이랑 교환 가능한가요', '2024-06-27 10:45:00', NULL),
(NULL, 22, '우와 깍두기 좋아요 저 물김치 있는데 교환해요', '2024-07-01 09:01:00', NULL),
(NULL, 23, '친구 속상하겠다 ㅠ 왜 바꿔요 ㅠ 일단 전 초코우유 조아하니까 교환해여', '2024-07-01 10:45:00', NULL),
(NULL, 25, '공부할때마다 새콤달콤 먹어요 아침마다 사기도 귀찮고 대량으로 사서 집에서 챙겨가면 편할거같아요', '2024-07-01 12:24:14', NULL),
(NULL, 26, '만든거요...?약간 위생걱정되긴하는데 보장가능하신가요 ㅠㅠ', '2024-07-01 15:01:30', NULL),
(NULL, 27, '미역줄기랑 바까요', '2024-07-02 08:00:00', NULL),
(NULL, 28, '제가 웬만한 카레는 다 먹어봤는데 또 새로운거네요!!', '2024-07-02 07:40:00', NULL),
(NULL, 29, '와 트러플 오일이랑 교환한 다음에 파김치도 같이 짜파게티 먹으면 대박이겠는데여 저랑 교환해여 마침 어머니가 어제 파김치 갖다 주셨어여', '2024-07-02 09:10:00', NULL),
(NULL, 30, '서울역 2시 2번출구 ㄱㄱ', '2024-07-02 11:03:00', NULL);


-- 일반 밀키트
INSERT 
  INTO mealkit 
(
  mealkit_id, mealkit_name, mealkit_photo, 
  mealkit_price, mealkit_ingredient, mealkit_calories, 
  mealkit_order_count, mealkit_stock, mealkit_created_at, 
  mealkit_updated_at, mealkit_deleted_at, admin_id, 
  mealkit_status
)
VALUES
(NULL, '밀웜씨리얼밀키트', '그림1', 5900, '밀웜, 오트밀, 꿀', 300, 150, 1, '2019-02-17 12:20:50', NULL, NULL, 2, '판매중'),
(NULL, '마라탕후루정식밀키트', '그림2', 11000, '마라소스, 돼지고기, 당근, 양파, 탕후루', 450, 120, 30, '2019-07-26 15:20:15', NULL, NULL, 2, '판매중'),
(NULL, '달팽이쫄면밀키트', '그림3', 8000, '달팽이, 쫄면, 양념장', 380, 50, 16, '2019-11-03 12:10:13', NULL, NULL, 2, '판매중'),
(NULL, '장수풍뎅이리조또밀키트', '그림4', 9200, '장수풍뎅이, 쌀, 양파, 파, 당근, 치즈', 272, 18, 70, '2020-01-28 13:20:15', NULL, NULL, 2, '판매중'),
(NULL, '귀뚜라미채소덮밥밀키트', '그림5', 10400, '귀뚜라미, 쌀, 야채, 양념', 210, 20, 30, '2020-07-06 15:20:15', NULL, NULL, 2, '판매중'),
(NULL, '곰팡이 스튜 밀키트', '그림6', 9900, '곰팡이, 당근, 양파,쪽파, 고기, 소스', 420, 13, 20, '2020-12-01 12:11:00', NULL, '2021-01-10 11:11:00', 4, '삭제'),
(NULL, '오징어 껍질 샐러드 밀키트', '그림7', 11000, '오징어 껍질, 쪽파, 대파, 양파, 발사믹드레싱', 360, 78, 34, '2020-12-01 13:11:00', NULL, NULL, 4, '판매중'),
(NULL, '고추 가득 꽁치 피자 밀키트', '그림8', 8900, '꽁치, 고추, 치즈, 도우, 토마토소스', 284, 98, 0, '2021-02-26 13:02:15', NULL, NULL, 2, '품절'),
(NULL, '녹차 닭발 밀키트', '그림9', 8900, '녹차, 닭발, 닭발 소스', 400, 14, 69, '2021-04-05 15:11:00', NULL, NULL, 4, '판매중'),
(NULL, '땅콩 치즈 라면 밀키트', '그림10', 4500, '땅콩, 라면, 치즈, 스프', 280, 200, 51, '2021-08-12 12:45:10', NULL, NULL, 1, '판매중'),
(NULL, '장수풍뎅이 라자냐 밀키트', '그림11', 9900, '장수풍뎅이, 라자냐, 라자냐 소스, 치즈', 397, 110, 44, '2021-08-13 15:43:50', NULL, NULL, 1, '판매중'),
(NULL, '닭머리 죽밥 밀키트', '그림12', 7000, '닭머리, 쌀, 당근, 고추', 320, 45, 20, '2022-02-01 08:11:00', NULL, NULL, 1, '판매중'),
(NULL, '황소 매운탕 밀키트', '그림13', 10000, '황소고기, 매운탕 양념, 당근, 양배추', 425, 23, 12, '2022-06-21 15:05:00', NULL, NULL, 1, '판매중'),
(NULL, '마시멜로 물회 밀키트', '그림14', 11000, '마시멜로, 물회소스, 양배추, 소면, 광어회, 우럭회, 오징어회, 소라', 410, 59, 7, '2022-07-01 12:01:00', NULL, NULL, 4, '판매중'),
(NULL, '싱싱한 지네 스파게티 밀키트', '그림15', 9000, '스파게티 소스, 지네, 스파게티 면', 350, 7, 21, '2022-07-26 13:18:15', NULL, NULL, 2, '판매중'),
(NULL, '두꺼비간장덮밥 밀키트', '그림16', 8000, '두꺼비, 쌀, 간장, 당근, 양파', 432, 120, 2, '2022-09-28 13:20:15', NULL, NULL, 3, '판매중'),
(NULL, '복숭아 해물 찌개 밀키트', '그림17', 11000, '복숭아, 오징어, 전복, 새우, 홍합, 찌개 양념', 380, 22, 0, '2022-11-26 15:01:31', NULL, NULL, 3, '품절'),
(NULL, '마늘 바나나 볶음밥 밀키트', '그림18', 9000, '마늘, 바나나, 쌀, 굴소스', 370, 43, 3, '2022-12-01 17:01:29', '2022-12-01 20:01:29', NULL, 3, '수정'),
(NULL, '오렌지 캐러멜 칠리 찌개 밀키트', '그림19', 10000, '오렌지, 캐러멜, 칠리소스, 찌개 양념', 405, 55, 2, '2022-12-25 16:20:15', NULL, NULL, 3, '판매중'),
(NULL, '고등어 크림 짜장면 밀키트', '그림20', 6000, '고등어, 짜장 소스, 면, 생크림', 320, 76, 12, '2023-03-26 15:20:15', NULL, NULL, 5, '판매중'),
(NULL, '번데기 떡갈비 밀키트', '그림21', 8900, '번데기, 다진 고기, 떡', 330, 99, 10, '2023-03-26 18:20:15', NULL, NULL, 2, '판매중'),
(NULL, '돈벌레 볶음면 밀키트', '그림22', 6400, '돈벌레, 면, 양파, 당근, 대파, 양념', 350, 100, 4, '2023-03-28 17:21:30', NULL, NULL, 1, '판매중'),
(NULL, '아홀로틀 구이 밀키트', '그림23', 10500, '아홀로틀, 간장', 314, 102, 20, '2023-05-16 15:20:15', NULL, NULL, 5, '판매중'),
(NULL, '3분 쿼리 밀키트', '그림24', 23100, '카레, 쌀, 마법소스', 348, 121, 11, '2023-06-29 14:05:14', NULL, NULL, 4, '판매중'),
(NULL, '오렌지 떡볶이 밀키트', '그림25', 6700, '오렌지, 떡, 떡볶이 양념', 342, 210, 30, '2023-07-03 12:20:15', NULL, NULL, 5, '판매중'),
(NULL, '장수풍뎅이 스시 밀키트', '그림26', 12300, '장수풍뎅이, 쌀, 와사비, 간장', 451, 340, 24, '2023-08-02 15:20:15', NULL, NULL, 5, '판매중'),
(NULL, '타이어 버블티 밀키트', '그림27', 4000, '타이어, 밀크티', 342, 4, 13, '2024-01-01 13:20:15', NULL, '2024-02-01 13:20:15', 3, '삭제'),
(NULL, '민트 초코 케밥 밀키트', '그림28', 9900, '민트초코, 또띠아, 파프리카', 340, 21, 5, '2024-01-26 11:20:15', NULL, NULL, 5, '판매중'),
(NULL, '생선잼 볶음밥 밀키트', '그림29', 7800, '생선잼, 볶음밥', 362, 5, 0, '2024-03-06 15:31:45', NULL, NULL, 5, '품절'),
(NULL, '초코 메뚜기 불고기 밀키트', '그림30', 12500, '초코, 메뚜기, 불고기', 441, 9, 3, '2024-04-28 17:02:32', NULL, NULL, 3, '판매중');


-- 일반 밀키트 리뷰
INSERT 
  INTO user_review 
(
  review_content, review_created_date, review_updated_at, 
  review_scope, user_id,mealkit_id
)
VALUES
('신선하고 고소한 밀웜이 오트밀과 환상적인 조화를 이루는 시리얼 밀키트입니다. 아침 식사로 딱이에요!', '2019-02-20 14:20:50', NULL, 4, 5, 1),
('와 탕후루가 진짜 대박이에요!!! 설탕 엄청 얇게 잘 코팅되어있어요 굿굿 마라탕은 당연히 맛있쬬', '2019-08-01 11:20:15', NULL, 5, 10, 2),
('달팽이 쫄면이 이렇게 쫄깃쫄깃하다니 믿을 수 없어요 또 시켜 먹고 싶어요', '2019-11-30 14:20:13', NULL, 4, 14, 3),
('장수풍뎅이랑 치즈의 조합이라니!! 그 누가 상상했겠어요 아묻따 별점 5점입니다', '2020-02-26 16:20:15', NULL, 5, 17, 4),
('귀뚜라미의 고소한 맛과 신선한 채소가 어우러져 건강한 한 끼 식사가 되는 덮밥 밀키트예요 요즘 시간은 없지만 건강은 챙기고픈 분께 강추예요', '2020-07-06 15:20:15', NULL, 4, 30, 5),
('곰팡이가 음식의 재료가 될줄은 상상도 못했는데 의외로 별미긴한데...흠.........', '2021-01-01 12:11:00', NULL, 1, 9, 6),
('오징어 껍질이 오징어 살보다 맛있는데요?', '2021-01-03 13:11:00', '2021-01-03 13:15:00', 4, 12, 7),
('기대하면서 시킨건데 뭔가 피자랑 꽁치는 안어울리는 느낌이긴하네요 ㅠㅠ 하지만 못먹을 정도는 아니에요', '2021-03-11 13:02:15', NULL, 3, 24, 8),
('녹차도 좋아하고 닭발도 좋아하는데 같이 먹을 수 있으면 완전 럭키비키자낭~!!!!', '2021-04-06 15:11:00', NULL, 4, 20, 9),
('땅콩...과 치즈는 좀 제스타일이아니긴 하네여.... 하지만 직접 돈주고 시킨거니 먹어야겠죠?', '2021-08-17 12:45:10', NULL, 2, 21, 10),
('제가 장수풍뎅이를 진짜 좋아하는데요 왜냐면 장수풍뎅이 식감이 진짜 좋거든요 그래서 장풍리도 시켜먹었는데 장풍라도 최고였어요', '2021-08-15 15:43:50', NULL, 5, 17, 11),
('몸이 안좋아서 죽 밀키트를 좀 시켜놨는데 시킨것중에 이게 제일 무난하니 맛있네요', '2022-02-11 08:11:00', NULL, 4, 23, 12),
('엄청매워요!!! 맵찔이는 조심해야해요 하지만 저는 맵짱이라 맛있게 먹었슴당 ㅎㅎㅎ', '2022-06-27 15:05:00', NULL, 4, 29, 13),
('물회에 마시멜로가 들어가니까 약간 옹심이 같기도하고 맛있어요 달달~하니 좋습니다', '2022-07-09 12:01:00', NULL, 4, 16, 14),
('지네 스파게티 너무 맛있어요 제가 이탈리아 유학생인데 거기 미슐랭 파이브스타 집 보다 맛있어요', '2022-07-30 15:18:15', NULL, 5, 15, 15),
('개인적으로는 다른 곳에서 파는 개구리간장덮밥이 더 먹을만 했던거같아요....두꺼비는 좀 질기네요....', '2022-10-02 12:10:15', NULL, 2, 7, 16),
('배송이 너무 늦게 왔어요ㅡㅡ 맛까지 없었으면 진짜 별점 1점 줬을지도몰라요!!!!', '2022-12-20 15:01:31', NULL, 3, 4, 17),
('마늘의 매운 맛을 바나나의 단 맛이 잡아줘서 금상첨화예요', '2022-12-10 17:01:29', NULL, 5, 2, 18),
('와 진짜 독특해요 오렌지랑 캐러멜도 독특한데 거기에 칠리까지? 약간 말로 표현할 수 없는 맛이지만 독특하다는 점에서 점수 드릴게요', '2023-01-09 16:20:15', NULL, 4, 21, 19),
('배송은 어제 왔는데 경비아저씨가 배달왔다고 했는데 만우절이라 뻥인줄알고 안찾아갔어요 근데 이거 진짜 맛있네요 하루 빨리 못먹은게 아쉬울정도예요', '2023-04-02 15:20:15', NULL, 5, 15, 20),
('번데기의 고소함과 떡갈비의 감칠맛이 어우러져 색다른 맛을 느낄 수 있어요', '2023-04-03 18:20:15', NULL, 4, 17, 21),
('가입하고 처음 시키는 밀키트인데 기대 이상이에요 ㅎㅎ 자주 시켜먹겠습니다', '2023-04-10 17:21:30', NULL, 4, 18, 22),
('아홀로틀의 부드러움과 양념이 조화를 이루네요 하지만 두번은 안시켜먹을듯', '2023-05-20 15:20:15', NULL, 3, 11, 23),
('밀키트 카레가 이렇게 맛있으면 인도는 어떡하라고요. 이름에서부터 긍정적인 기운이 느껴져서 입에넣자마자 눈물이 났어요', '2023-07-03 14:05:14', NULL, 5, 26, 24),
('오렌지는 상큼하고 떡볶이는 매콤하고...이맛도 저맛도아닌 느낌이에요', '2023-07-11 12:20:15', NULL, 2, 6, 25),
('장수풍뎅이리조또 장수풍뎅이라자냐 다 시켜먹어본 장수풍뎅이 마니아입니다. 이건 좀 실망스럽네요. 장수풍뎅이가 맛없을 수 있다는 걸 이번 밀키트를 통해 처음 알게되었습니다.', '2023-08-10 15:20:15', '2023-08-10 15:25:15', 2, 17, 26),
('타이어 밀크티라니ㅋㅋ 타이어의 쫄깃함에 턱이 나갔어요 턱강화 원하시는 분들 강추 ><', '2024-01-16 13:20:15', NULL, 4, 8, 27),
('민트초코러버는 안시켜먹을 수 없는 음식이에용!', '2024-02-02 11:20:15', NULL, 5, 20, 28),
('무난히 맛있었어요 생선잼을 볶음밥 말고 빵이랑 먹어도 맛있을거같아요! 응용도 가능한 밀키트!', '2024-03-16 15:31:45', NULL, 3, 27, 29),
('메뚜기가 초코랑 만나니까 세상에 없던 맛이에요', '2024-05-02 17:02:32', NULL, 2, 26, 30);

-- 베스트 레시피 밀키트
INSERT 
  INTO best_recipe_mealkit 
(
  `best_mealkit_name`, `best_mealkit_price`, `best_mealkit_ingredient`, 
  `best_mealkit_calories`, `best_mealkit_order_count`, `best_mealkit_stock`, 
  `best_mealkit_updated_at`, `best_mealkit_created_at`, `best_selected_time`, 
  `best_mealkit_deleted_at`, `best_author`, `admin_id`, `best_mealkit_photo`, `best_mealkit_status`
) 
VALUES
('매미 튀김덮밥 밀키트', 9500, '매미, 쌀, 간장 소스, 당근, 양파, 쪽파', 700, 100, 0, NULL, '2019-03-01 08:20:00', '2019-04-01 08:20:00', NULL, 'minjungku', 2, '그림1', '품절'),
('참새 꼬치 밀키트', 11200, '참새, 꼬치, 양념장, 대파, 양파', 400, 9, 41, '2019-06-09 11:20:00', '2019-07-01 08:20:00', '2019-06-01 08:20:00', NULL, 'jisung', 2, '그림2', '수정'),
('개구리 수프 밀키트', 12000, '개구리, 수프 베이스, 감자, 양파, 브로콜리', 300, 80, 20, NULL, '2019-09-01 08:20:00', '2019-10-01 08:20:00', NULL, 'hyunwooj', 2, '그림3', '삭제'),
('치즈 민트 피자 밀키트', 10300, '피자 도우, 치즈, 민트 잎, 토마토 소스', 1000, 100, 0, NULL, '2019-12-01 08:20:00', '2020-01-01 08:20:00', NULL, 'hyunjin', 2, '그림4', '품절'),
('호박 두부 샐러드 밀키트', 8700, '호박, 두부, 샐러드 드레싱, 양상추, 깻잎, 파프리카', 350, 150, 0, NULL, '2020-03-01 08:20:00', '2020-04-01 08:20:00', NULL, 'jiyoung', 2, '그림5', '품절'),
('코코넛 새우카레 밀키트', 13500, '새우, 코코넛 밀크, 카레 소스, 당근, 감자, 양파, 햄', 600, 11, 89, '2020-06-11 08:20:00', '2020-07-01 08:20:00', '2020-06-01 08:20:00', NULL, 'yesle', 2, '그림6', '수정'),
('블루베리 고등어 스튜 밀키트', 12800, '고등어, 블루베리, 스튜 베이스, 브로콜리, 양파, 대파', 500, 70, 30, '2020-09-21 11:20:00', '2020-10-01 08:20:00', '2020-09-01 08:20:00', NULL, 'jiho', 2, '그림7', '수정'),
('양파 초코 스프 밀키트', 7600, '양파, 초콜릿, 수프 베이스', 250, 13, 87, NULL, '2020-12-01 08:20:00', '2021-01-01 08:20:00', NULL, 'hyunwoo', 4, '그림8', '판매중'),
('라임 닭고기 덮밥 밀키트', 9300, '닭고기, 라임, 쌀, 쪽파, 후추, 간장소스', 700, 140, 10, NULL, '2021-03-01 08:20:00', '2021-04-01 08:20:00', NULL, 'areum', 4, '그림9', '판매중'),
('타조알 볶음밥 밀키트', 15000, '타조알, 쌀, 채소, 간장 소스', 600, 60, 40, NULL, '2021-06-01 08:20:00', '2021-07-01 08:20:00', NULL, 'minhyeok', 2, '그림10', '판매중'),
('뱀고기 파스타 밀키트', 14200, '뱀고기, 파스타 면, 파스타 소스, 채소', 800, 90, 10, NULL, '2021-09-01 08:20:00', '2021-10-01 08:20:00', NULL, 'jisung', 1, '그림11', '판매중'),
('말린 고구마 장조림 밀키트', 6500, '말린 고구마, 간장, 메추리알, 양파', 300, 120, 30, NULL, '2021-12-01 08:20:00', '2022-01-01 08:20:00', NULL, 'jihye', 1, '그림12', '판매중'),
('마늘 초코 찜닭 밀키트', 11900, '닭고기, 마늘, 초콜릿, 찜닭 소스', 700, 99, 1, NULL, '2022-03-01 08:20:00', '2022-04-01 08:20:00', NULL, 'hangyeol', 1, '그림13', '판매중'),
('두리안 샐러드 밀키트', 13000, '두리안, 샐러드 드레싱, 양상추, 파프리카, 옥수수', 400, 70, 30, NULL, '2022-06-01 08:20:00', '2022-07-01 08:20:00', NULL, 'juhui', 4, '그림14', '판매중'),
('연어 딸기 크림 밀키트', 14800, '연어, 딸기, 크림 소스, 양파, 양상추', 750, 90, 10, NULL, '2022-09-01 08:20:00', '2022-10-01 08:20:00', NULL, 'donghoon', 3, '그림15', '판매중'),
('파프리카 멸치 볶음 밀키트', 7800, '파프리카, 멸치, 양념장, 아몬드', 350, 101, 49, NULL, '2022-12-01 08:20:00', '2023-01-01 08:20:00', NULL, 'hyunjin', 3, '그림16', '판매중'),
('뽕잎 쭈꾸미 구이 밀키트', 12500, '주꾸미, 뽕잎, 구이 소스, 대파, 양파', 500, 80, 20, NULL, '2023-03-01 08:20:00', '2023-04-01 08:20:00', NULL, 'younghee', 5, '그림17', '판매중'),
('호두 훈제 오리 밀키트', 16200, '훈제 오리, 호두, 양념장, 양파, 감자', 600, 109, 41, NULL, '2023-06-01 08:20:00', '2023-07-01 08:20:00', NULL, 'dongmin', 1, '그림18', '판매중'),
('감자 옥수수 죽 밀키트', 8000, '감자, 옥수수, 죽 베이스', 300, 130, 20, NULL, '2023-09-01 08:20:00', '2023-10-01 08:20:00', NULL, 'seoyeon', 3, '그림19', '판매중'),
('토마토 군소 리조또 밀키트', 13800, '군소, 토마토, 리조또 재료, 양파, 감자, 대파', 600, 93, 57, NULL, '2023-12-01 08:20:00', '2024-01-01 08:20:00', NULL, 'dahee', 5, '그림20', '판매중'),
('무화과 해물 파스타 밀키트', 14500, '무화과, 해물, 파스타 면, 파스타 소스', 750, 90, 10, '2024-03-11 09:20:00', '2024-04-01 08:20:00', '2024-03-01 08:20:00', NULL, 'dongmin', 1, '그림21', '수정'),
('브로콜리 바나나 볶음 밀키트', 9000, '브로콜리, 바나나, 양념장, 양파, 대파', 350, 140, 10, NULL, '2024-06-01 08:20:00', '2024-07-01 08:20:00', '2024-07-01 09:10:02', 'jisung', 3, '그림22', '삭제');

-- 베스트 레시피 밀키트 리뷰
INSERT 
  INTO best_recipe_user_review 
( 
  `review_content`, `review_created_date`, `review_scope`, 
  `best_mealkit_id`, `user_id`, `review_updated_at`
)
VALUES
('배송은 빨랐어요 ~ 이제서야 리뷰남기네요 ㅎㅎ 매미가 질기지않았는데 혹시 숙성시키신건가요 ㅜㅜ 너무 맛있어요 .. 양도 많아서 점심이랑 저녁 두번 나눠서 먹었어요 !!', '2019-05-18 08:20:00', 5, 1, 25, NULL),
('참새가 질길줄알았는데 술안주로도 정말 잘어울려요 혼술 안주 추천드립니다 ㅋㅋ', '2019-07-18 08:20:00', 4, 2, 25, '2019-07-19 08:20:00'),
('개구리는 구워서만 먹어봤지 수프로 만들어 먹어본적이 없었는데 환상의 맛이네요.. 아침 대용으로 너무 좋은것 같아요 !!!!!!!', '2019-11-28 08:20:00', 5, 3, 28, NULL),
('민트랑 치즈가 생각보다 너무 잘어울려서 놀랐어요. 두 재료 너무 좋아하는데 민트 매니아에겐 체고였어요 굿. 배송도 굿', '2020-01-08 08:20:00', 5, 4, 24, NULL),
('호박 두부 샐러드는 뭐 ... 맛없없 아닐까요  특제 샐러드 소스가 ㄹㅇ 맛도리 입니다. 강추 ㅋㅋ', '2020-08-18 08:20:00', 3, 5, 12, NULL),
('코코넛을 평소에도 즐겨먹는데 ~ 새우랑 만나니까 향이 잘 어우러지네요 ~ 카레의 맛이 더 깊어지는 느낌이에요 재구매의사 100%', '2020-08-03 08:20:00', 4, 6, 12, NULL),
('블루베리가 고등어의 잡내를 잘잡아줘서 스튜로 만들어먹기 딱좋네요 .. 미쳤어요.. 고등어가 상하면 어쩌나 했는데 포장 잘해주셨어요 ㅜㅜ', '2020-10-28 08:20:00', 5, 7, 9, NULL),
('양파가 상쾌하니까 초코의 텁텁함이랑 조화가 굿잡이에요 !!!!!! 재구매 쌉 ㅜㅜ', '2021-01-27 08:20:00', 5, 8, 5, NULL),
('닭고기가 너무 부드러워서 마시멜로인줄알았어요 밀키트라 기대안했는데 완전 기대 이상이에요', '2021-04-13 08:20:00', 5, 9, 10, NULL),
('이게 타조알이 들어가니까 노른자가 엄청 커서 고소해요!!!! 진짜 대박 재구매 고고싱', '2021-08-12 08:20:00', 5, 10, 17, NULL),
('작년인가요? 뱀 요리를 먹어본적이있는데 너무 비려서 트라우마 생겼었는데 이거 먹으니까 내가 왜 뱀고기를 싫어했나 싶을 정도예요', '2021-11-16 08:20:00', 4, 11, 19, NULL),
('와 고구마를 말린다음에 장조림으로 할 생각을 하다니... 우리 게시판 이용자들 엄청 창의력 넘치는데요? 저도 이런 아이디어 내는 사람이 되고싶네요', '2022-01-15 08:20:00', 4, 12, 9, NULL),
('찜닭이랑 초코는 언제 먹어도 진리. 거기에 마늘까지 추가되니까 진짜 부드럽고, 잡내가 하나도 없어요 당충전 완 !!', '2022-04-19 08:20:00', 4, 13, 27, NULL),
('두리안을 평소에 즐겨먹는 편이 아닌데 이 샐러드 밀키트는 싱싱해서 그런가 ..? 드레싱도 맛있어서 두리안이랑 같이 흡입했어요 ㅜㅜ ..재구매 의사 100 %', '2022-07-12 08:20:00', 4, 14, 21, NULL),
('제가 좋아하는 음식을 한번에 먹을 수 있는것이 천국 그자체... 그리고 연어가 생각보다 두툼해서 한입에 먹는 맛이 있어요, 딸기랑 크림은 두말하면 잔소리죠 ?? 계속 출시해주세요 ~~', '2022-10-18 08:20:00', 5, 15, 2, NULL),
('파프리카별로 안좋아하는데 멸치랑 볶으니까 생각보다 매운맛이 하나도 안나고 특제 소스가 밥이랑 먹기 딱좋아서 두공기나 먹었습니다 ㅜㅜ', '2023-01-12 08:20:00', 5, 16, 7, NULL),
('원래 쭈꾸미를 상추랑만 먹었었는데 뽕잎 와.... 어떻게 이런 생각을 하셨을까 ... 노벨상 부탁드립니다.', '2023-04-12 08:20:00', 5, 17, 10, '2023-04-12 09:20:00'),
('오리를 훈제했는데 그 사이에 호두가 들어간 느낌? 씹으면 씹을수록 고소하니 기름기를 싹 잡아주네요 ㅜㅜ ', '2023-08-13 08:20:00', 3, 18, 12, NULL),
('제가 일주일간 아파서 아무것도 제대로 못먹었는데 이게 진짜 너무 맛있어보여서 속는셈 치고 사봤는데.. 맨날 먹고싶네요.. 사랑해요.', '2023-10-16 08:20:00', 4, 19, 18, NULL),
('군소 원래 즐겨먹는 음식인데 토마토랑같이 리조또 해먹으니까 진짜 .. 너무 부드러운데 씹는맛이 죽여줘요.. 다른 리조또도 출시 해주세요!!!', '2024-01-19 08:20:00', 5, 20, 22, NULL),
('해물파스타에 무화과 조합이라니 >< 장금이가 울고갔어요 방금 제가 봤어요', '2024-04-26 08:20:00', 3, 21, 23, NULL),
('제가 브로콜리도 싫어하고 바나나도 싫어하는데 같이 먹으니까 완전 말도 안되는 맛이네요 긍정적으로요. 최고예요 베스트레시피밀키트 많이 많이 선정되어서 제 편견을 깨줬으면 좋겠어요', '2024-07-03 08:20:00', 4, 22, 14, NULL);


-- 식단 관리
INSERT 
  INTO diet_calendar_record
(
  `diet_calendar_record_id`,`diet_name`,`diet_time`,
  `diet_photo`,`diet_calories`,`user_id`
)
VALUES 
(NULL, '매미 튀김덮밥 밀키트', '2019-08-21 14:45:03','베스트레시피밀키트 그림 1', '1000', 1),
(NULL, '호박 두부 샐러드 밀키트', '2009-03-01 18:15:09','베스트레시피밀키트 그림 5', '2500', 3),
(NULL, '타조알 볶음밥 밀키트', '2010-10-23 12:51:12','베스트레시피밀키트 그림 10', '1500', 4),
(NULL, '황소 매운탕 밀키트', '2023-11-26 08:25:54','밀키트 그림 13', '1750', 6),
(NULL, '초코 메뚜기 불고기 밀키트', '2015-06-30 09:41:39','밀키트 그림 30', '2000', 26);


-- 레시피 게시글
INSERT 
  INTO recipe 
(
  recipe_id, recipe_name, recipe_created_at, 
  recipe_update_at, recipe_ingredient, recipe_describe, 
  recipe_calories, recipe_cooking_time, recipe_servings, 
  recipe_difficulty, recipe_likes_count, user_id
) 
VALUES
(NULL, '레시피 1', '2019-01-01 08:20:00', '2019-02-03 08:20:00', '재료 1, 재료 2', '레시피 1의 설명입니다', 387, '10 분', '4 인분', '상', 1, 19),
(NULL, '레시피 2', '2019-01-02 08:20:00', '2019-02-04 08:20:00', '재료 3, 재료 4', '레시피 2의 설명입니다', 140, '20 분', '4 인분', '하', 1, 5),
(NULL, '레시피 3', '2019-01-03 08:20:00', '2019-02-05 08:20:00', '재료 5, 재료 6', '레시피 3의 설명입니다', 178, '15 분', '3 인분', '하', 1, 12),
(NULL, '레시피 4', '2019-01-04 08:20:00', '2019-02-06 08:20:00', '재료 7, 재료 8', '레시피 4의 설명입니다', 315, '20 분', '1 인분', '중', 1, 27),
(NULL, '레시피 5', '2019-01-05 08:20:00', '2019-02-07 08:20:00', '재료 9, 재료 10', '레시피 5의 설명입니다', 204, '15 분', '1 인분', '중', 1, 16),
(NULL, '매미 튀김덮밥', '2019-02-02 08:20:00', '2019-03-03 08:20:00', '재료 10, 재료 19', '레시피 6의 설명입니다', 362, '12 분', '1 인분', '중', 6, 20),
(NULL, '참새 꼬치', '2019-05-02 08:20:00', '2019-06-03 08:20:00', '재료 5, 재료 17', '레시피 7의 설명입니다', 424, '30 분', '3 인분', '하', 6, 28),
(NULL, '개구리 수프', '2019-08-02 08:20:00', '2019-09-03 08:20:00', '재료 6, 재료 13', '레시피 8의 설명입니다', 428, '3 분', '4 인분', '중', 6, 19),
(NULL, '치즈 민트 피자', '2019-11-02 08:20:00', '2019-12-03 08:20:00', '재료 9, 재료 17', '레시피 9의 설명입니다', 353, '5 분', '4 인분', '상', 6, 17),
(NULL, '호박 두부 샐러드', '2020-02-02 08:20:00', '2020-03-03 08:20:00', '재료 3, 재료 14', '레시피 10의 설명입니다', 336, '2 분', '4 인분', '상', 6, 12),
(NULL, '코코넛 새우카레', '2020-05-02 08:20:00', '2020-06-03 08:20:00', '재료 2, 재료 15', '레시피 11의 설명입니다', 439, '3 분', '1 인분', '중', 6, 24),
(NULL, '블루베리 고등어 스튜', '2020-08-02 08:20:00', '2020-09-03 08:20:00', '재료 2, 재료 14', '레시피 12의 설명입니다', 443, '5 분', '4 인분', '중', 6, 30),
(NULL, '양파 초코 스프', '2020-11-02 08:20:00', '2020-12-03 08:20:00', '재료 9, 재료 18', '레시피 13의 설명입니다', 320, '10 분', '1 인분', '하', 6, 13),
(NULL, '라임 닭고기 덮밥', '2021-02-02 08:20:00', '2021-03-03 08:20:00', '재료 4, 재료 15', '레시피 14의 설명입니다', 273, '10 분', '1 인분', '상', 6, 14),
(NULL, '타조알 볶음밥', '2021-05-02 08:20:00', '2021-06-03 08:20:00', '재료 1, 재료 15', '레시피 15의 설명입니다', 174, '5 분', '2 인분', '상', 6, 25),
(NULL, '뱀고기 파스타', '2021-08-02 08:20:00', '2021-09-03 08:20:00', '재료 10, 재료 16', '레시피 16의 설명입니다', 294, '15 분', '4 인분', '하', 6, 28),
(NULL, '말린 고구마 장조림', '2021-11-02 08:20:00', '2021-12-03 08:20:00', '재료 10, 재료 16', '레시피 17의 설명입니다', 313, '10 분', '4 인분', '하', 6, 16),
(NULL, '마늘 초코 찜닭', '2022-02-02 08:20:00', '2022-03-03 08:20:00', '재료 6, 재료 18', '레시피 18의 설명입니다', 387, '5 분', '2 인분', '상', 6, 8),
(NULL, '두리안 샐러드', '2022-05-02 08:20:00', '2022-06-03 08:20:00', '재료 7, 재료 12', '레시피 19의 설명입니다', 223, '10 분', '2 인분', '중', 6, 29),
(NULL, '연어 딸기 크림', '2022-08-02 08:20:00', '2022-09-03 08:20:00', '재료 5, 재료 11', '레시피 20의 설명입니다', 440, '2 분', '3 인분', '하', 6, 15),
(NULL, '파프리카 멸치 볶음', '2022-11-02 08:20:00', '2022-12-03 08:20:00', '재료 6, 재료 20', '레시피 21의 설명입니다', 474, '10 분', '1 인분', '하', 6, 17),
(NULL, '뽕잎 쭈꾸미 구이', '2023-02-02 08:20:00', '2023-03-03 08:20:00', '재료 8, 재료 17', '레시피 22의 설명입니다', 179, '10 분', '3 인분', '중', 6, 2),
(NULL, '호두 훈제 오리', '2023-05-02 08:20:00', '2023-06-03 08:20:00', '재료 6, 재료 13', '레시피 23의 설명입니다', 341, '15 분', '3 인분', '하', 6, 18),
(NULL, '감자 옥수수 죽', '2023-08-02 08:20:00', '2023-09-03 08:20:00', '재료 8, 재료 11', '레시피 24의 설명입니다', 278, '19 분', '2 인분', '하', 6, 22),
(NULL, '토마토 군소 리조또', '2023-11-02 08:20:00', '2023-12-03 08:20:00', '재료 10, 재료 12', '레시피 25의 설명입니다', 349, '20 분', '4 인분', '하', 6, 11),
(NULL, '무화과 해물 파스타', '2024-02-02 08:20:00', '2024-03-03 08:20:00', '재료 10, 재료 17', '레시피 26의 설명입니다', 256, '16 분', '3 인분', '중', 6, 18),
(NULL, '브로콜리 바나나 볶음', '2024-05-02 08:20:00', '2024-06-03 08:20:00', '재료 3, 재료 12', '레시피 27의 설명입니다', 435, '17 분', '4 인분', '중', 6, 28),
(NULL, '레시피 28', '2024-05-03 08:20:00', '2024-06-04 08:20:00', '재료 3, 재료 15', '레시피 28의 설명입니다', 133, '21 분', '3 인분', '하', 1, 27),
(NULL, '레시피 29', '2024-05-04 08:20:00', '2024-06-05 08:20:00', '재료 4, 재료 13', '레시피 29의 설명입니다', 130, '17 분', '1 인분', '하', 1, 16),
(NULL, '레시피 30', '2024-05-05 08:20:00', '2024-06-06 08:20:00', '재료 3, 재료 12', '레시피 30의 설명입니다', 421, '15 분', '3 인분', '상', 1, 19);


-- 레시피 좋아요
INSERT 
  INTO recipe_likes 
(
  like_id, recipe_id, like_created_at, user_id
) 
VALUES
(NULL, 1, '2019-01-01 08:20:00', 27),
(NULL, 2, '2019-01-02 08:20:00', 3),
(NULL, 3, '2019-01-03 08:20:00', 11),
(NULL, 4, '2019-01-04 08:20:00', 19),
(NULL, 5, '2019-01-05 08:20:00', 5),
(NULL, 6, '2019-02-03 08:20:00', 29),
(NULL, 6, '2019-02-03 08:20:00', 10),
(NULL, 6, '2019-02-03 08:20:00', 25),
(NULL, 6, '2019-02-03 08:20:00', 18),
(NULL, 6, '2019-02-03 08:20:00', 4),
(NULL, 6, '2019-02-03 08:20:00', 16),
(NULL, 7, '2019-05-03 08:20:00', 9),
(NULL, 7, '2019-05-03 08:20:00', 20),
(NULL, 7, '2019-05-03 08:20:00', 1),
(NULL, 7, '2019-05-03 08:20:00', 15),
(NULL, 7, '2019-05-03 08:20:00', 22),
(NULL, 7, '2019-05-03 08:20:00', 13),
(NULL, 8, '2019-08-03 08:20:00', 6),
(NULL, 8, '2019-08-03 08:20:00', 28),
(NULL, 8, '2019-08-03 08:20:00', 17),
(NULL, 8, '2019-08-03 08:20:00', 23),
(NULL, 8, '2019-08-03 08:20:00', 21),
(NULL, 8, '2019-08-03 08:20:00', 7),
(NULL, 9, '2019-11-03 08:20:00', 2),
(NULL, 9, '2019-11-03 08:20:00', 30),
(NULL, 9, '2019-11-03 08:20:00', 8),
(NULL, 9, '2019-11-03 08:20:00', 14),
(NULL, 9, '2019-11-03 08:20:00', 12),
(NULL, 9, '2019-11-03 08:20:00', 26),
(NULL, 10, '2020-02-03 08:20:00', 24),
(NULL, 10, '2020-02-03 08:20:00', 30),
(NULL, 10, '2020-02-03 08:20:00', 5),
(NULL, 10, '2020-02-03 08:20:00', 17),
(NULL, 10, '2020-02-03 08:20:00', 21),
(NULL, 10, '2020-02-03 08:20:00', 9),
(NULL, 11, '2020-05-03 08:20:00', 25),
(NULL, 11, '2020-05-03 08:20:00', 18),
(NULL, 11, '2020-05-03 08:20:00', 13),
(NULL, 11, '2020-05-03 08:20:00', 3),
(NULL, 11, '2020-05-03 08:20:00', 27),
(NULL, 11, '2020-05-03 08:20:00', 6),
(NULL, 12, '2020-08-03 08:20:00', 2),
(NULL, 12, '2020-08-03 08:20:00', 1),
(NULL, 12, '2020-08-03 08:20:00', 10),
(NULL, 12, '2020-08-03 08:20:00', 23),
(NULL, 12, '2020-08-03 08:20:00', 28),
(NULL, 12, '2020-08-03 08:20:00', 16),
(NULL, 13, '2020-11-03 08:20:00', 7),
(NULL, 13, '2020-11-03 08:20:00', 14),
(NULL, 13, '2020-11-03 08:20:00', 12),
(NULL, 13, '2020-11-03 08:20:00', 4),
(NULL, 13, '2020-11-03 08:20:00', 22),
(NULL, 13, '2020-11-03 08:20:00', 15),
(NULL, 14, '2021-02-03 08:20:00', 8),
(NULL, 14, '2021-02-03 08:20:00', 11),
(NULL, 14, '2021-02-03 08:20:00', 26),
(NULL, 14, '2021-02-03 08:20:00', 24),
(NULL, 14, '2021-02-03 08:20:00', 19),
(NULL, 14, '2021-02-03 08:20:00', 20),
(NULL, 15, '2021-05-03 08:20:00', 29),
(NULL, 15, '2021-05-03 08:20:00', 13),
(NULL, 15, '2021-05-03 08:20:00', 6),
(NULL, 15, '2021-05-03 08:20:00', 3),
(NULL, 15, '2021-05-03 08:20:00', 25),
(NULL, 15, '2021-05-03 08:20:00', 27),
(NULL, 16, '2021-08-03 08:20:00', 1),
(NULL, 16, '2021-08-03 08:20:00', 12),
(NULL, 16, '2021-08-03 08:20:00', 2),
(NULL, 16, '2021-08-03 08:20:00', 23),
(NULL, 16, '2021-08-03 08:20:00', 17),
(NULL, 16, '2021-08-03 08:20:00', 28),
(NULL, 17, '2021-11-03 08:20:00', 16),
(NULL, 17, '2021-11-03 08:20:00', 11),
(NULL, 17, '2021-11-03 08:20:00', 9),
(NULL, 17, '2021-11-03 08:20:00', 22),
(NULL, 17, '2021-11-03 08:20:00', 4),
(NULL, 17, '2021-11-03 08:20:00', 30),
(NULL, 18, '2022-02-03 08:20:00', 8),
(NULL, 18, '2022-02-03 08:20:00', 26),
(NULL, 18, '2022-02-03 08:20:00', 19),
(NULL, 18, '2022-02-03 08:20:00', 7),
(NULL, 18, '2022-02-03 08:20:00', 21),
(NULL, 18, '2022-02-03 08:20:00', 10),
(NULL, 19, '2022-05-03 08:20:00', 24),
(NULL, 19, '2022-05-03 08:20:00', 15),
(NULL, 19, '2022-05-03 08:20:00', 18),
(NULL, 19, '2022-05-03 08:20:00', 14),
(NULL, 19, '2022-05-03 08:20:00', 20),
(NULL, 19, '2022-05-03 08:20:00', 29),
(NULL, 20, '2022-08-03 08:20:00', 5),
(NULL, 20, '2022-08-03 08:20:00', 12),
(NULL, 20, '2022-08-03 08:20:00', 3),
(NULL, 20, '2022-08-03 08:20:00', 27),
(NULL, 20, '2022-08-03 08:20:00', 13),
(NULL, 20, '2022-08-03 08:20:00', 8),
(NULL, 21, '2022-11-03 08:20:00', 6),
(NULL, 21, '2022-11-03 08:20:00', 1),
(NULL, 21, '2022-11-03 08:20:00', 11),
(NULL, 21, '2022-11-03 08:20:00', 25),
(NULL, 21, '2022-11-03 08:20:00', 17),
(NULL, 21, '2022-11-03 08:20:00', 14),
(NULL, 22, '2023-02-03 08:20:00', 2),
(NULL, 22, '2023-02-03 08:20:00', 21),
(NULL, 22, '2023-02-03 08:20:00', 7),
(NULL, 22, '2023-02-03 08:20:00', 19),
(NULL, 22, '2023-02-03 08:20:00', 30),
(NULL, 22, '2023-02-03 08:20:00', 28),
(NULL, 23, '2023-05-03 08:20:00', 4),
(NULL, 23, '2023-05-03 08:20:00', 23),
(NULL, 23, '2023-05-03 08:20:00', 16),
(NULL, 23, '2023-05-03 08:20:00', 24),
(NULL, 23, '2023-05-03 08:20:00', 10),
(NULL, 23, '2023-05-03 08:20:00', 15),
(NULL, 24, '2023-08-03 08:20:00', 22),
(NULL, 24, '2023-08-03 08:20:00', 9),
(NULL, 24, '2023-08-03 08:20:00', 18),
(NULL, 24, '2023-08-03 08:20:00', 20),
(NULL, 24, '2023-08-03 08:20:00', 5),
(NULL, 24, '2023-08-03 08:20:00', 29),
(NULL, 25, '2023-11-03 08:20:00', 26),
(NULL, 25, '2023-11-03 08:20:00', 6),
(NULL, 25, '2023-11-03 08:20:00', 27),
(NULL, 25, '2023-11-03 08:20:00', 13),
(NULL, 25, '2023-11-03 08:20:00', 3),
(NULL, 25, '2023-11-03 08:20:00', 11),
(NULL, 26, '2024-02-03 08:20:00', 19),
(NULL, 26, '2024-02-03 08:20:00', 5),
(NULL, 26, '2024-02-03 08:20:00', 29),
(NULL, 26, '2024-02-03 08:20:00', 10),
(NULL, 26, '2024-02-03 08:20:00', 25),
(NULL, 26, '2024-02-03 08:20:00', 18),
(NULL, 27, '2024-05-03 08:20:00', 4),
(NULL, 27, '2024-05-03 08:20:00', 16),
(NULL, 27, '2024-05-03 08:20:00', 9),
(NULL, 27, '2024-05-03 08:20:00', 20),
(NULL, 27, '2024-05-03 08:20:00', 1),
(NULL, 27, '2024-05-03 08:20:00', 15),
(NULL, 28, '2024-05-04 08:20:00', 22),
(NULL, 29, '2024-05-05 08:20:00', 13),
(NULL, 30, '2024-05-06 08:20:00', 6);


-- 레시피 사진
INSERT 
  INTO recipe_photos 
(
  photos_id, recipe_id, recipe_photo
) 
VALUES
(NULL, 1, 'photo_1.jpg'),
(NULL, 1, 'photo_2.jpg'),
(NULL, 1, 'photo_3.jpg'),
(NULL, 2, 'photo_4.jpg'),
(NULL, 2, 'photo_5.jpg'),
(NULL, 2, 'photo_6.jpg'),
(NULL, 3, 'photo_7.jpg'),
(NULL, 3, 'photo_8.jpg'),
(NULL, 3, 'photo_9.jpg'),
(NULL, 4, 'photo_10.jpg'),
(NULL, 4, 'photo_11.jpg'),
(NULL, 4, 'photo_12.jpg'),
(NULL, 5, 'photo_13.jpg'),
(NULL, 5, 'photo_14.jpg'),
(NULL, 5, 'photo_15.jpg'),
(NULL, 6, 'photo_16.jpg'),
(NULL, 6, 'photo_17.jpg'),
(NULL, 6, 'photo_18.jpg'),
(NULL, 7, 'photo_19.jpg'),
(NULL, 7, 'photo_20.jpg'),
(NULL, 7, 'photo_21.jpg'),
(NULL, 8, 'photo_22.jpg'),
(NULL, 8, 'photo_23.jpg'),
(NULL, 8, 'photo_24.jpg'),
(NULL, 9, 'photo_25.jpg'),
(NULL, 9, 'photo_26.jpg'),
(NULL, 9, 'photo_27.jpg'),
(NULL, 10, 'photo_28.jpg'),
(NULL, 10, 'photo_29.jpg'),
(NULL, 10, 'photo_30.jpg'),
(NULL, 11, 'photo_31.jpg'),
(NULL, 11, 'photo_32.jpg'),
(NULL, 11, 'photo_33.jpg'),
(NULL, 12, 'photo_34.jpg'),
(NULL, 12, 'photo_35.jpg'),
(NULL, 12, 'photo_36.jpg'),
(NULL, 13, 'photo_37.jpg'),
(NULL, 13, 'photo_38.jpg'),
(NULL, 13, 'photo_39.jpg'),
(NULL, 14, 'photo_40.jpg'),
(NULL, 14, 'photo_41.jpg'),
(NULL, 14, 'photo_42.jpg'),
(NULL, 15, 'photo_43.jpg'),
(NULL, 15, 'photo_44.jpg'),
(NULL, 15, 'photo_45.jpg'),
(NULL, 16, 'photo_46.jpg'),
(NULL, 16, 'photo_47.jpg'),
(NULL, 16, 'photo_48.jpg'),
(NULL, 17, 'photo_49.jpg'),
(NULL, 17, 'photo_50.jpg'),
(NULL, 17, 'photo_51.jpg'),
(NULL, 18, 'photo_52.jpg'),
(NULL, 18, 'photo_53.jpg'),
(NULL, 18, 'photo_54.jpg'),
(NULL, 19, 'photo_55.jpg'),
(NULL, 19, 'photo_56.jpg'),
(NULL, 19, 'photo_57.jpg'),
(NULL, 20, 'photo_58.jpg'),
(NULL, 20, 'photo_59.jpg'),
(NULL, 20, 'photo_60.jpg'),
(NULL, 21, 'photo_61.jpg'),
(NULL, 21, 'photo_62.jpg'),
(NULL, 21, 'photo_63.jpg'),
(NULL, 22, 'photo_64.jpg'),
(NULL, 22, 'photo_65.jpg'),
(NULL, 22, 'photo_66.jpg'),
(NULL, 23, 'photo_67.jpg'),
(NULL, 23, 'photo_68.jpg'),
(NULL, 23, 'photo_69.jpg'),
(NULL, 24, 'photo_70.jpg'),
(NULL, 24, 'photo_71.jpg'),
(NULL, 24, 'photo_72.jpg'),
(NULL, 25, 'photo_73.jpg'),
(NULL, 25, 'photo_74.jpg'),
(NULL, 25, 'photo_75.jpg'),
(NULL, 26, 'photo_76.jpg'),
(NULL, 26, 'photo_77.jpg'),
(NULL, 26, 'photo_78.jpg'),
(NULL, 27, 'photo_79.jpg'),
(NULL, 27, 'photo_80.jpg'),
(NULL, 27, 'photo_81.jpg'),
(NULL, 28, 'photo_82.jpg'),
(NULL, 28, 'photo_83.jpg'),
(NULL, 28, 'photo_84.jpg'),
(NULL, 29, 'photo_85.jpg'),
(NULL, 29, 'photo_86.jpg'),
(NULL, 29, 'photo_87.jpg'),
(NULL, 30, 'photo_88.jpg'),
(NULL, 30, 'photo_89.jpg'),
(NULL, 30, 'photo_90.jpg');


-- 레시피 댓글 
INSERT 
  INTO recipe_comment 
(
  recipe_comment_id, recipe_id, recipe_comment_content,
  recipe_comment_created_at, recipe_comment_updated_at, user_id
) 
VALUES
(NULL, 1, '레시피 1의 첫 번째 댓글입니다', '2019-01-02 08:20:00', '2019-01-03 08:20:00', 25),
(NULL, 1, '레시피 1의 두 번째 댓글입니다', '2019-01-03 08:20:00', '2019-01-04 08:20:00', 14),
(NULL, 2, '레시피 2의 첫 번째 댓글입니다', '2019-01-03 08:20:00', '2019-01-04 08:20:00', 28),
(NULL, 2, '레시피 2의 두 번째 댓글입니다', '2019-01-04 08:20:00', '2019-01-05 08:20:00', 9),
(NULL, 3, '레시피 3의 첫 번째 댓글입니다', '2019-01-04 08:20:00', '2019-01-05 08:20:00', 6),
(NULL, 3, '레시피 3의 두 번째 댓글입니다', '2019-01-05 08:20:00', '2019-01-06 08:20:00', 3),
(NULL, 4, '레시피 4의 첫 번째 댓글입니다', '2019-01-05 08:20:00', '2019-01-06 08:20:00', 27),
(NULL, 4, '레시피 4의 두 번째 댓글입니다', '2019-01-06 08:20:00', '2019-01-07 08:20:00', 19),
(NULL, 5, '레시피 5의 첫 번째 댓글입니다', '2019-01-06 08:20:00', '2019-01-07 08:20:00', 15),
(NULL, 5, '레시피 5의 두 번째 댓글입니다', '2019-01-07 08:20:00', '2019-01-08 08:20:00', 24),
(NULL, 6, '레시피 6의 첫 번째 댓글입니다', '2019-02-03 08:20:00', '2019-02-04 08:20:00', 17),
(NULL, 6, '레시피 6의 두 번째 댓글입니다', '2019-02-04 08:20:00', '2019-02-05 08:20:00', 4),
(NULL, 7, '레시피 7의 첫 번째 댓글입니다', '2019-05-03 08:20:00', '2019-05-04 08:20:00', 23),
(NULL, 7, '레시피 7의 두 번째 댓글입니다', '2019-05-04 08:20:00', '2019-05-05 08:20:00', 11),
(NULL, 8, '레시피 8의 첫 번째 댓글입니다', '2019-08-03 08:20:00', '2019-08-04 08:20:00', 30),
(NULL, 8, '레시피 8의 두 번째 댓글입니다', '2019-08-04 08:20:00', '2019-08-05 08:20:00', 1),
(NULL, 9, '레시피 9의 첫 번째 댓글입니다', '2019-11-03 08:20:00', '2019-11-04 08:20:00', 7),
(NULL, 9, '레시피 9의 두 번째 댓글입니다', '2019-11-04 08:20:00', '2019-11-05 08:20:00', 21),
(NULL, 10, '레시피 10의 첫 번째 댓글입니다', '2020-02-03 08:20:00', '2020-02-04 08:20:00', 18),
(NULL, 10, '레시피 10의 두 번째 댓글입니다', '2020-02-04 08:20:00', '2020-02-05 08:20:00', 12),
(NULL, 11, '레시피 11의 첫 번째 댓글입니다', '2020-05-03 08:20:00', '2020-05-04 08:20:00', 8),
(NULL, 11, '레시피 11의 두 번째 댓글입니다', '2020-05-04 08:20:00', '2020-05-05 08:20:00', 16),
(NULL, 12, '레시피 12의 첫 번째 댓글입니다', '2020-08-03 08:20:00', '2020-08-04 08:20:00', 10),
(NULL, 12, '레시피 12의 두 번째 댓글입니다', '2020-08-04 08:20:00', '2020-08-05 08:20:00', 22),
(NULL, 13, '레시피 13의 첫 번째 댓글입니다', '2020-11-03 08:20:00', '2020-08-06 08:20:00', 29),
(NULL, 13, '레시피 13의 두 번째 댓글입니다', '2020-11-04 08:20:00', '2020-08-07 08:20:00', 13),
(NULL, 14, '레시피 14의 첫 번째 댓글입니다', '2021-02-03 08:20:00', '2020-08-08 08:20:00', 2),
(NULL, 14, '레시피 14의 두 번째 댓글입니다', '2021-02-04 08:20:00', '2020-08-09 08:20:00', 5),
(NULL, 15, '레시피 15의 첫 번째 댓글입니다', '2021-05-03 08:20:00', '2020-08-10 08:20:00', 20),
(NULL, 15, '레시피 15의 두 번째 댓글입니다', '2021-05-04 08:20:00', '2020-08-11 08:20:00', 26),
(NULL, 16, '레시피 16의 첫 번째 댓글입니다', '2021-08-03 08:20:00', '2020-08-12 08:20:00', 7),
(NULL, 16, '레시피 16의 두 번째 댓글입니다', '2021-08-04 08:20:00', '2020-08-13 08:20:00', 14),
(NULL, 17, '레시피 17의 첫 번째 댓글입니다', '2021-11-03 08:20:00', '2020-08-14 08:20:00', 19),
(NULL, 17, '레시피 17의 두 번째 댓글입니다', '2021-11-04 08:20:00', '2020-08-15 08:20:00', 23),
(NULL, 18, '레시피 18의 첫 번째 댓글입니다', '2022-02-03 08:20:00', '2020-08-16 08:20:00', 17),
(NULL, 18, '레시피 18의 두 번째 댓글입니다', '2022-02-04 08:20:00', '2020-08-17 08:20:00', 28),
(NULL, 19, '레시피 19의 첫 번째 댓글입니다', '2022-05-03 08:20:00', '2020-08-18 08:20:00', 25),
(NULL, 19, '레시피 19의 두 번째 댓글입니다', '2022-05-04 08:20:00', '2020-08-19 08:20:00', 30),
(NULL, 20, '레시피 20의 첫 번째 댓글입니다', '2022-08-03 08:20:00', '2020-08-20 08:20:00', 21),
(NULL, 20, '레시피 20의 두 번째 댓글입니다', '2022-08-04 08:20:00', '2020-08-21 08:20:00', 6),
(NULL, 21, '레시피 21의 첫 번째 댓글입니다', '2022-11-03 08:20:00', '2020-08-22 08:20:00', 9),
(NULL, 21, '레시피 21의 두 번째 댓글입니다', '2022-11-04 08:20:00', '2020-08-23 08:20:00', 4),
(NULL, 22, '레시피 22의 첫 번째 댓글입니다', '2023-02-03 08:20:00', '2020-08-24 08:20:00', 3),
(NULL, 22, '레시피 22의 두 번째 댓글입니다', '2023-02-04 08:20:00', '2020-08-25 08:20:00', 8),
(NULL, 23, '레시피 23의 첫 번째 댓글입니다', '2023-05-03 08:20:00', '2020-08-26 08:20:00', 16),
(NULL, 23, '레시피 23의 두 번째 댓글입니다', '2023-05-04 08:20:00', '2020-08-27 08:20:00', 11),
(NULL, 24, '레시피 24의 첫 번째 댓글입니다', '2023-08-03 08:20:00', '2020-08-28 08:20:00', 15),
(NULL, 24, '레시피 24의 두 번째 댓글입니다', '2023-08-04 08:20:00', '2020-08-29 08:20:00', 22),
(NULL, 25, '레시피 25의 첫 번째 댓글입니다', '2023-11-03 08:20:00', '2020-08-30 08:20:00', 18),
(NULL, 25, '레시피 25의 두 번째 댓글입니다', '2023-11-04 08:20:00', '2020-08-31 08:20:00', 27),
(NULL, 26, '레시피 26의 첫 번째 댓글입니다', '2024-02-03 08:20:00', '2020-09-01 08:20:00', 2),
(NULL, 26, '레시피 26의 두 번째 댓글입니다', '2024-02-04 08:20:00', '2020-09-02 08:20:00', 13),
(NULL, 27, '레시피 27의 첫 번째 댓글입니다', '2024-05-03 08:20:00', '2020-09-03 08:20:00', 12),
(NULL, 27, '레시피 27의 두 번째 댓글입니다', '2024-05-04 08:20:00', '2020-09-04 08:20:00', 20),
(NULL, 28, '레시피 28의 첫 번째 댓글입니다', '2024-05-04 08:20:00', '2020-09-05 08:20:00', 10),
(NULL, 28, '레시피 28의 두 번째 댓글입니다', '2024-05-05 08:20:00', '2020-09-06 08:20:00', 1),
(NULL, 29, '레시피 29의 첫 번째 댓글입니다', '2024-05-05 08:20:00', '2020-09-07 08:20:00', 24),
(NULL, 29, '레시피 29의 두 번째 댓글입니다', '2024-05-06 08:20:00', '2020-09-08 08:20:00', 5),
(NULL, 30, '레시피 30의 첫 번째 댓글입니다', '2024-05-07 08:20:00', '2020-09-09 08:20:00', 26),
(NULL, 30, '레시피 30의 두 번째 댓글입니다', '2024-05-08 08:20:00', '2020-09-10 08:20:00', 29);
