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
    `user_deleted_at` timestamp NOT NULL,
    `user_status` VARCHAR(255) NOT NULL,
    PRIMARY KEY (`user_id`)
) ENGINE=INNODB AUTO_INCREMENT=1 COMMENT='회원';

CREATE TABLE `admin` (
    `admin_id` bigint(20) NOT NULL AUTO_INCREMENT,
    `comany_number` VARCHAR(255) NOT NULL,
    `admin_password` VARCHAR(255) NOT NULL,
    `admin_name` VARCHAR(255) NOT NULL,
    `admin_service_years` VARCHAR(255) NOT NULL,
    `admin_created_at` timestamp NOT NULL,
    `admin_created_atd` timestamp NULL,
    `admin_status` VARCHAR(255) NOT NULL,
    PRIMARY KEY (`admin_id`)
) ENGINE=INNODB AUTO_INCREMENT=1 COMMENT='관리자';

CREATE TABLE `mealkit` (
    `mealkit_id` bigint(20) NOT NULL AUTO_INCREMENT,
    `mealkit_name` VARCHAR(255) NOT NULL,
    `mealkit_price` VARCHAR(255) NOT NULL,
    `mealkit_ingredient` VARCHAR(255) NULL,
    `mealkit_calories` VARCHAR(255) NOT NULL,
    `mealkit_order_count` VARCHAR(255) NULL,
    `mealkit_stock` VARCHAR(255) NOT NULL,
    `mealkit_created_at` timestamp NOT NULL,
    `mealkit_updated_at` timestamp NULL,
    `mealkit_deleted_at` timestamp NULL,
    `admin_id` bigint(20) NOT NULL,
    PRIMARY KEY (`mealkit_id`),
    FOREIGN KEY (`admin_id`) REFERENCES `admin`(`admin_id`) ON DELETE CASCADE
) ENGINE=INNODB AUTO_INCREMENT=1 COMMENT='밀키트';

CREATE TABLE `recipe` (
    `recipe_id` bigint(20) NOT NULL AUTO_INCREMENT,
    `recipe_name` VARCHAR(255) NOT NULL,
    `recipe_created_at` timestamp NOT NULL,
    `Field` VARCHAR(255) NULL,
    `recipe_describe` VARCHAR(255) NOT NULL,
    `recipe_calories` VARCHAR(255) NOT NULL,
    `recipe_cooking_time` VARCHAR(255) NOT NULL,
    `recipe_servings` VARCHAR(255) NOT NULL,
    `recipe_difficulty` VARCHAR(255) NULL,
    `recipe_likes_count` VARCHAR(255) NULL,
    `user_id` bigint(20) NOT NULL,
    PRIMARY KEY (`recipe_id`),
    FOREIGN KEY (`user_id`) REFERENCES `member`(`user_id`) ON DELETE CASCADE
) ENGINE=INNODB AUTO_INCREMENT=1 COMMENT='레시피';

CREATE TABLE `best_recipe_mealkit` (
    `best_mealkit_id` bigint(20) NOT NULL AUTO_INCREMENT,
    `best_mealkit_name` VARCHAR(255) NOT NULL,
    `best_mealkit_price` VARCHAR(255) NOT NULL,
    `best_mealkit_ingredient` VARCHAR(255) NULL,
    `best_mealkit_calories` VARCHAR(255) NOT NULL,
    `best_mealkit_order_count` VARCHAR(255) NULL,
    `best_mealkit_stock` VARCHAR(255) NOT NULL,
    `best_mealkit_created_at` timestamp NOT NULL,
    `best_mealkit_updated_at` timestamp NULL,
    `best_mealkit_deleted_at` timestamp NULL,
    `best_author` VARCHAR(255) NOT NULL,
    `best_selected_time` timestamp NOT NULL,
    `admin_id` bigint(20) NOT NULL,
    PRIMARY KEY (`best_mealkit_id`),
    FOREIGN KEY (`admin_id`) REFERENCES `admin`(`admin_id`) ON DELETE CASCADE
) ENGINE=INNODB AUTO_INCREMENT=1 COMMENT='베스트 레시피 밀키트';

CREATE TABLE `recipe_likes` (
    `like_id` bigint(20) NOT NULL AUTO_INCREMENT,
    `recipe_id` bigint(20) NOT NULL,
    `Field` timestamp NULL,
    `user_id` bigint(20) NOT NULL,
    PRIMARY KEY (`like_id`, `recipe_id`),
    FOREIGN KEY (`recipe_id`) REFERENCES `recipe`(`recipe_id`) ON DELETE CASCADE,
    FOREIGN KEY (`user_id`) REFERENCES `member`(`user_id`) ON DELETE CASCADE
) ENGINE=INNODB AUTO_INCREMENT=1 COMMENT='레시피 좋아요';

CREATE TABLE `cart` (
    `cart_id` bigint(20) NOT NULL AUTO_INCREMENT,
    `Field` VARCHAR(255) NULL,
    `Field2` VARCHAR(255) NULL,
    `mealkit_id` bigint(20) NOT NULL,
    `best_mealkit_id` bigint(20) NOT NULL,
    `user_id` bigint(20) NOT NULL,
    PRIMARY KEY (`cart_id`),
    FOREIGN KEY (`mealkit_id`) REFERENCES `mealkit`(`mealkit_id`) ON DELETE CASCADE,
    FOREIGN KEY (`best_mealkit_id`) REFERENCES `best_recipe_mealkit`(`best_mealkit_id`) ON DELETE CASCADE,
    FOREIGN KEY (`user_id`) REFERENCES `member`(`user_id`) ON DELETE CASCADE
) ENGINE=INNODB AUTO_INCREMENT=1 COMMENT='장바구니';

CREATE TABLE `orders` (
    `order_id` bigint(20) NOT NULL AUTO_INCREMENT,
    `order_date` timestamp NOT NULL,
    `order_status` VARCHAR(255) NOT NULL,
    `order_cancel_at` timestamp NULL,
    `cart_id` bigint(20) NOT NULL,
    PRIMARY KEY (`order_id`),
    FOREIGN KEY (`cart_id`) REFERENCES `cart`(`cart_id`) ON DELETE CASCADE
) ENGINE=INNODB AUTO_INCREMENT=1 COMMENT='주문';

CREATE TABLE `recipe_comment` (
    `recipe_comment_id` bigint(20) NOT NULL AUTO_INCREMENT,
    `recipe_id` bigint(20) NOT NULL,
    `recipe_comment_content` VARCHAR(255) NULL,
    `recipe_comment_created_at` timestamp NULL,
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
    `diet_calories` VARCHAR(255) NULL,
    `user_id` bigint(20) NOT NULL,
    PRIMARY KEY (`diet_calendar_record_id`),
    FOREIGN KEY (`user_id`) REFERENCES `member`(`user_id`) ON DELETE CASCADE
) ENGINE=INNODB AUTO_INCREMENT=1 COMMENT='식단 기록';

CREATE TABLE `meal_exchanges` (
    `meal_exchanges_id` bigint(20) NOT NULL AUTO_INCREMENT,
    `meal_exchanges_title` VARCHAR(255) NULL,
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
    `review_scope` VARCHAR(255) NOT NULL,
    `mealkit_id` bigint(20) NOT NULL,
    `user_id` bigint(20) NOT NULL,
    PRIMARY KEY (`review_id`),
    FOREIGN KEY (`mealkit_id`) REFERENCES `mealkit`(`mealkit_id`) ON DELETE CASCADE,
    FOREIGN KEY (`user_id`) REFERENCES `member`(`user_id`) ON DELETE CASCADE
) ENGINE=INNODB AUTO_INCREMENT=1 COMMENT='밀키트 사용자 리뷰';

CREATE TABLE `best_recipe_user_review` (
    `review_id` bigint(20) NOT NULL AUTO_INCREMENT,
    `review_content` VARCHAR(255) NULL,
    `review_created_date` timestamp NULL,
    `review_scope` VARCHAR(255) NULL,
    `user_id` bigint(20) NOT NULL,
    `best_mealkit_id` bigint(20) NOT NULL,
    PRIMARY KEY (`review_id`),
    FOREIGN KEY (`user_id`) REFERENCES `member`(`user_id`) ON DELETE CASCADE,
    FOREIGN KEY (`best_mealkit_id`) REFERENCES `best_recipe_mealkit`(`best_mealkit_id`) ON DELETE CASCADE
) ENGINE=INNODB AUTO_INCREMENT=1 COMMENT='베스트 레시피 밀키트 사용자 리뷰';

CREATE TABLE `meal_exchanges_comment` (
    `recipe_comment_id` bigint(20) NOT NULL AUTO_INCREMENT,
    `meal_exchanges_id` bigint(20) NOT NULL,
    `recipe_comment_content` VARCHAR(255) NULL,
    `recipe_comment_created_at` timestamp NULL,
    PRIMARY KEY (`recipe_comment_id`, `meal_exchanges_id`),
    FOREIGN KEY (`meal_exchanges_id`) REFERENCES `meal_exchanges`(`meal_exchanges_id`) ON DELETE CASCADE
) ENGINE=INNODB AUTO_INCREMENT=1 COMMENT='식재료 게시글 댓글';
