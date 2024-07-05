DROP TRIGGER IF EXISTS after_order_cancel;
DROP TRIGGER IF EXISTS after_order_cancel_plus;

DELIMITER //

-- 주문 취소 시 장바구니 상태 업데이트 트리거
CREATE TRIGGER after_order_cancel
AFTER UPDATE ON orders
FOR EACH ROW
BEGIN
    -- 주문 상태가 '주문취소'로 변경된 경우
    IF NEW.order_status = '주문취소' THEN
        -- 해당 주문의 장바구니 상태를 '주문취소'로 업데이트
        UPDATE cart
        SET cart_status = '주문취소'
        WHERE cart_id = NEW.cart_id;
    END IF;
END; //

DELIMITER ;


DELIMITER //

CREATE TRIGGER after_order_cancel_plus
AFTER UPDATE ON cart
FOR EACH ROW
BEGIN
    -- 주문 상태가 '주문취소'로 변경된 경우
    IF NEW.cart_status = '주문취소' THEN
        -- best_recipe_mealkit 테이블 업데이트: best_mealkit_stock 증가
        UPDATE best_recipe_mealkit b
        SET b.best_mealkit_stock = b.best_mealkit_stock + (
            SELECT c.best_mealkit_order_count
            FROM cart c
            WHERE c.cart_id = NEW.cart_id
        )
        WHERE b.best_mealkit_id = NEW.best_mealkit_id;

        -- mealkit 테이블 업데이트: mealkit_stock 증가
        UPDATE mealkit m
        SET m.mealkit_stock = m.mealkit_stock + (
            SELECT c.mealkit_order_count
            FROM cart c
            WHERE c.cart_id = NEW.cart_id
        )
        WHERE m.mealkit_id = NEW.mealkit_id;
    END IF;
END //

DELIMITER ;





UPDATE orders
SET 
    order_cancel_at = NOW(),
    order_status = '주문취소'
WHERE order_id = 1;

SELECT * FROM orders;
SELECT * FROM cart;
SELECT * FROM mealkit;
SELECT * FROM best_recipe_mealkit;