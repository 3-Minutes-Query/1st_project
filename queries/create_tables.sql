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

-- Create tables
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
    `user_created_at` timestamp NOT NULL,
    `user_deleted_at` timestamp NULL,
    `user_status` VARCHAR(255) NOT NULL CHECK(user_status IN ('활성','비활성')),
    PRIMARY KEY (`user_id`)
) ENGINE=INNODB AUTO_INCREMENT=1 COMMENT='회원';

CREATE TABLE `admin` (
    `admin_id` bigint(20) NOT NULL AUTO_INCREMENT,
    `comany_number` VARCHAR(255) NOT NULL,
    `admin_password` VARCHAR(255) NOT NULL,
    `admin_name` VARCHAR(255) NOT NULL,
    `admin_service_years` int NOT NULL,
    `admin_created_at` timestamp NOT NULL,
    `admin_created_atd` timestamp NULL,
    `admin_status` VARCHAR(255) NOT NULL CHECK(admin_status IN ('활성','비활성')),
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
    `mealkit_created_at` timestamp NOT NULL,
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
    `recipe_created_at` timestamp NOT NULL,
    `recipe_update_at` timestamp NULL,
    `recipe_ingredient` VARCHAR(255) NOT NULL,
    `recipe_describe` VARCHAR(255) NOT NULL,
    `recipe_calories` int NULL,
    `recipe_cooking_time` VARCHAR(255) NOT NULL,
    `recipe_servings` VARCHAR(255) NOT NULL,
    `recipe_difficulty` VARCHAR(255) NOT NULL CHECK(recipe_difficulty IN ('상','중','하')),
    `recipe_likes_count` int NOT NULL,
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
    `best_mealkit_created_at` timestamp NOT NULL,
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
    `like_created_at` timestamp NOT NULL,
    `user_id` bigint(20) NOT NULL,
    PRIMARY KEY (`like_id`, `recipe_id`),
    FOREIGN KEY (`recipe_id`) REFERENCES `recipe`(`recipe_id`) ON DELETE CASCADE,
    FOREIGN KEY (`user_id`) REFERENCES `member`(`user_id`) ON DELETE CASCADE
) ENGINE=INNODB AUTO_INCREMENT=1 COMMENT='레시피 좋아요';

CREATE TABLE `cart` (
    `cart_id` bigint(20) NOT NULL AUTO_INCREMENT,
    `mealkit_order_count` int NOT NULL,
    `best_mealkit_order_count` int NOT NULL,
    `mealkit_id` bigint(20) NOT NULL,
    `best_mealkit_id` bigint(20) NOT NULL,
    `user_id` bigint(20) NOT NULL,
    `cart_status` VARCHAR(255) NOT NULL CHECK(cart_status IN ('주문전','주문','주문취소')),
    PRIMARY KEY (`cart_id`),
    FOREIGN KEY (`mealkit_id`) REFERENCES `mealkit`(`mealkit_id`) ON DELETE CASCADE,
    FOREIGN KEY (`best_mealkit_id`) REFERENCES `best_recipe_mealkit`(`best_mealkit_id`) ON DELETE CASCADE,
    FOREIGN KEY (`user_id`) REFERENCES `member`(`user_id`) ON DELETE CASCADE
) ENGINE=INNODB AUTO_INCREMENT=1 COMMENT='장바구니';

CREATE TABLE `orders` (
    `order_id` bigint(20) NOT NULL AUTO_INCREMENT,
    `order_date` timestamp NOT NULL,
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
    `recipe_comment_created_at` timestamp NOT NULL,
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
    `meal_exchanges_created_at` timestamp NOT NULL,
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
    `review_created_date` timestamp NOT NULL,
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
    `review_created_date` timestamp NOT NULL,
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
    `meal_comment_created_at` timestamp NOT NULL,
    `meal_comment_updated_at` timestamp NULL,
    PRIMARY KEY (`meal_comment_id`, `meal_exchanges_id`),
    FOREIGN KEY (`meal_exchanges_id`) REFERENCES `meal_exchanges`(`meal_exchanges_id`) ON DELETE CASCADE
) ENGINE=INNODB AUTO_INCREMENT=1 COMMENT='식재료 게시글 댓글';
