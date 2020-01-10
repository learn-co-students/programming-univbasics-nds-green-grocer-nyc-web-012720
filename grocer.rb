def find_item_by_name_in_collection(name, collection)

  i = 0
  while i < collection.length do
    item = collection[i][:item]
    if name != item
      nil
    else
      return collection[i]
    end
    i += 1
  end
end

def consolidate_cart(cart)
  new_cart = []
  i = 0
  while i < cart.length do
    name = cart[i][:item]
    working_item = find_item_by_name_in_collection(name, new_cart)

    if working_item
      working_item[:count] += 1
    else
      new_item = {
        :item => name,
        :price => cart[i][:price],
        :clearance => cart[i][:clearance],
        :count => 1
      }
      new_cart << new_item
    end
    i += 1
  end
  new_cart
end

def apply_coupons(cart, coupons)
  i = 0
  while i < coupons.length
    name = coupons[i][:item]
    cart_item = find_item_by_name_in_collection(name, cart)

    coupon_item_name = "#{name} W/COUPON"

    cart_item_with_coupon = find_item_by_name_in_collection(coupon_item_name, cart)

    if cart_item && cart_item[:count] >= coupons[i][:num]
      if cart_item_with_coupon
        cart_item_with_coupon[:count] += coupons[i][:num]
        cart_item[i] -= coupons[i][:num]
      else
        cart_item_with_coupon = {
          :item => coupon_item_name,
          :price => coupons[i][:cost] / coupons[i][:num],
          :clearance => cart_item[:clearance],
          :count => coupons[i][:num],
        }
        cart << cart_item_with_coupon
        cart_item[:count] -= coupons[i][:num]
      end
    end
    i += 1
  end
  cart
end

def apply_clearance(cart)
  i = 0
  while i < cart.length
    name = cart[i][:item]
    working_item = find_item_by_name_in_collection(name, cart)

    if working_item[:clearance] == true
      price_change = cart[i][:price] * 0.80
      cart[i][:price] = price_change.round(2)
    end
    i += 1
  end
  cart
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  couponed_cart = apply_coupons(consolidated_cart, coupons)
  final_cart = apply_clearance(couponed_cart)

  grand_total = 0
  i = 0

  while i < final_cart.length do
    price_per_item = final_cart[i][:price] * final_cart[i][:count]
    grand_total += price_per_item

    i += 1
  end
  if grand_total > 100.00
    grand_total = (grand_total * 0.90).round(2)
  end
  grand_total
end
