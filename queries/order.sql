/* 주문 완료ㅎㅎ  */
-- 트리거가 존재하면 삭제하는 쿼리
DROP TRIGGER IF EXISTS before_cart_insert;
DROP TRIGGER IF EXISTS after_order_insert;

DELIMITER //

-- 장바구니에 상품 추가 시 재고 확인 트리거
CREATE TRIGGER before_cart_insert
BEFORE INSERT ON cart
FOR EACH ROW
BEGIN
    -- 재고를 저장할 변수 선언
    DECLARE stock INT;

    -- 밀키트 재고 확인
    IF NEW.mealkit_id IS NOT NULL THEN
        -- 밀키트 테이블에서 해당 밀키트의 재고를 조회
        SELECT mealkit_stock INTO stock FROM mealkit WHERE mealkit_id = NEW.mealkit_id;
        -- 주문하려는 수량이 재고보다 많으면 예외 발생
        IF stock < NEW.mealkit_order_count THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '밀키트 재고가 부족합니다.';
        END IF;
    END IF;

    -- 베스트 레시피 밀키트 재고 확인
    IF NEW.best_mealkit_id IS NOT NULL THEN
        -- 베스트 레시피 밀키트 테이블에서 해당 밀키트의 재고를 조회
        SELECT best_mealkit_stock INTO stock FROM best_recipe_mealkit WHERE best_mealkit_id = NEW.best_mealkit_id;
        -- 주문하려는 수량이 재고보다 많으면 예외 발생
        IF stock < NEW.best_mealkit_order_count THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '베스트 레시피 밀키트 재고가 부족합니다.';
        END IF;
    END IF;
END; //

-- 주문 추가 시 재고 업데이트 및 판매 개수 증가 트리거
CREATE TRIGGER after_order_insert
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
    DECLARE v_mealkit_id BIGINT;
    DECLARE v_best_mealkit_id BIGINT;
    DECLARE v_mealkit_order_count INT;
    DECLARE v_best_mealkit_order_count INT;
    
    DECLARE done INT DEFAULT 0;
    DECLARE cart_cursor CURSOR FOR 
        SELECT mealkit_id, best_mealkit_id, mealkit_order_count, best_mealkit_order_count 
        FROM cart WHERE cart_id = NEW.cart_id;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    OPEN cart_cursor;
    
    read_loop: LOOP
        FETCH cart_cursor INTO v_mealkit_id, v_best_mealkit_id, v_mealkit_order_count, v_best_mealkit_order_count;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- 일반 밀키트 재고 업데이트 및 총 판매 개수 증가
        IF v_mealkit_id IS NOT NULL THEN
            UPDATE mealkit
            SET mealkit_stock = mealkit_stock - v_mealkit_order_count,
                mealkit_order_count = mealkit_order_count + v_mealkit_order_count
            WHERE mealkit_id = v_mealkit_id;
        END IF;

        -- 베스트 레시피 밀키트 재고 업데이트 및 총 판매 개수 증가
        IF v_best_mealkit_id IS NOT NULL THEN
            UPDATE best_recipe_mealkit
            SET best_mealkit_stock = best_mealkit_stock - v_best_mealkit_order_count,
                best_mealkit_order_count = best_mealkit_order_count + v_best_mealkit_order_count
            WHERE best_mealkit_id = v_best_mealkit_id;
        END IF;
        
        -- 장바구니 상태 업데이트
        UPDATE cart
        SET cart_status = '주문'
        WHERE cart_id = NEW.cart_id;
    END LOOP;
    
    CLOSE cart_cursor;
END; //

DELIMITER ;

-- 장바구니 추가
-- 2번 밀키트 1개, 2번 베스트 레시피 밀키트3개 
INSERT INTO cart (mealkit_order_count, best_mealkit_order_count, cart_status, mealkit_id, best_mealkit_id, user_id)
VALUES (1, 3, '주문전', 2, 2, 1);

-- 2번 밀키트 1개(재고수량 30개-> 29개) ,
-- 2번 베스트 레시피 밀키트3개(재고수량 41개-> 38개) 
INSERT INTO orders (order_status, cart_id)
VALUES ('주문', 1);

SELECT * FROM mealkit;
SELECT * FROM best_recipe_mealkit;

SELECT * FROM cart;