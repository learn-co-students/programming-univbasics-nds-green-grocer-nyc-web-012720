def find_item_by_name_in_collection(name, collection)
i=0
found_item = {}
  while i < collection.length do
    if collection[i][:item] === name
      return collection[i]
    end
      i += 1
  end
nil
end

def consolidate_cart(cart)
  i = 0
  cons_cart = []
    while i < cart.length do
      item_name = cart[i][:item]
      sought_item = find_item_by_name_in_collection(item_name, cons_cart)
      if sought_item
        sought_item[:count] += 1
      else
        cart[i][:count] = 1
        cons_cart << cart[i]
      end
      i += 1
    end

    cons_cart
  end

def make_coupon (coupon)
  rounded_price = (coupon[:cost].to_f / coupon[:num]).round(2)
  {item: "#{coupon[:item]} W/COUPON",
  price: rounded_price,
  count: coupon[:num]}
end

def coupon_matching (matching_item, coupon, cart)
  matching_item[:count] -= coupon[:num]
  coupon_item = make_coupon(coupon)
  coupon_item[:clearance] = matching_item[:clearance]
  cart << coupon_item
end

def apply_coupons(cart, coupons)
  coupon_cart = []
  i = 0
    while i < coupons.length do
    coupon = coupons[i]
    item_with_coupon = find_item_by_name_in_collection(coupon[:item], cart)
      if item_with_coupon[:count] >= coupon[:num]
        coupon_matching(item_with_coupon, coupon, cart)
      end
      i += 1
    end
  cart
end


def apply_clearance(cart)
i=0
clearance_cart = []
while i < cart.length
  item = cart[i]
    if item[:clearance]
      item[:price] = (0.8 * item[:price]).round(2)
      clearance_cart << item
    else
      clearance_cart << item
    end
    i+=1
  end
  clearance_cart
end

def checkout(cart, coupons)
cons_cart = []
coupon_cart = []
clearance_cart = []

cons_cart = consolidate_cart(cart)
coupon_cart = apply_coupons(cons_cart, coupons)
clearance_cart = apply_clearance(coupon_cart)

i = 0
total = 0

while i < clearance_cart.length do
  total += (clearance_cart[i][:price].to_f * clearance_cart[i][:count].to_f)
  i += 1
end
if total > 100
  total = 0.9 * total
end
total
end
