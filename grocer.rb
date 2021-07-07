def find_item_by_name_in_collection(name, collection)
  item_counter = 0
  while item_counter < collection.length do
    if name === collection[item_counter][:item]
      return collection[item_counter]
    end
    item_counter += 1
  end
  nil
end

def consolidate_cart(cart)
  new_cart = []
  item_counter = 0
  while item_counter < cart.length do
    new_cart_item = find_item_by_name_in_collection(cart[item_counter][:item], new_cart)
    if new_cart_item
      new_cart_item[:count] += 1
    else
      new_cart_item = cart[item_counter]
      new_cart_item[:count] = 1
      new_cart << new_cart_item
    end
    item_counter += 1
  end
  new_cart
end

def apply_coupons(cart, coupons)
  coupon_counter = 0
  while coupon_counter < coupons.length do
    cart_checker = find_item_by_name_in_collection(coupons[coupon_counter][:item], cart)
    coupon_item_name = "#{coupons[coupon_counter][:item]} W/COUPON"
    couponed_item_name_checker = find_item_by_name_in_collection(coupon_item_name, cart)
    if cart_checker && cart_checker[:count] >= coupons[coupon_counter][:num]
      if couponed_item_name_checker
        couponed_item_name_checker[:count] += coupons[coupon_counter][:num]
        cart_checker[:count] -= coupons[coupon_counter][:num]
      else
        couponed_item_name_checker = {
          item: coupon_item_name,
          price: coupons[coupon_counter][:cost] / coupons[coupon_counter][:num],
          clearance: cart_checker[:clearance],
          count: coupons[coupon_counter][:num]
        }
        cart << couponed_item_name_checker
        cart_checker[:count] -= coupons[coupon_counter][:num]
      end
    end
    coupon_counter += 1
  end
  cart
end

def apply_clearance(cart)
  counter = 0
  while counter < cart.length do
    if cart[counter][:clearance] === true
      cart[counter][:price] *= 0.8
      cart[counter][:price].round(2)
    end
    counter += 1
  end
  cart
end

def checkout(cart, coupons)
  unique_cart = consolidate_cart(cart)
  unique_cart_with_coupons = apply_coupons(unique_cart, coupons)
  unique_cart_coupons_clearance = apply_clearance(unique_cart_with_coupons)
  grand_total = 0
  counter = 0
  while counter < unique_cart_coupons_clearance.length do
    item_total = unique_cart_coupons_clearance[counter][:price] * unique_cart_coupons_clearance[counter][:count]
    grand_total += item_total
    counter += 1
  end
  if grand_total > 100
    grand_total *= 0.9
  end
  grand_total.round(2)
end
