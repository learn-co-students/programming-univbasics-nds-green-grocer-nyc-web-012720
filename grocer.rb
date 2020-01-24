def find_item_by_name_in_collection(name, collection)
  # Implement me first!
  i = 0
  while i < collection.length do
    if name == collection[i][:item]
      return collection[i]
    end
    i += 1
  end
  nil
  # Consult README for inputs and outputs
end

def consolidate_cart(cart)
  # Consult README for inputs and outputs
  #cart is a collection of item hashes
  new_cart = []
  i = 0
  while i < cart.length do
    item_hash = cart[i]
    item_name = item_hash[:item]
    sought_item = find_item_by_name_in_collection(item_name,new_cart)
    if sought_item
      sought_item[:count] += 1
    else
      cart[i][:count] = 1
      new_cart << cart[i]
    end
    i += 1

  end
new_cart
  # REMEMBER: This returns a new Array that represents the cart. Don't merely
  # change `cart` (i.e. mutate) it. It's easier to return a new thing.
end

def mk_coupon_hash(c)
  rounded_unit_price = (c[:cost].to_f * 1.0 / c[:num]).round(2)
  {
    :item => "#{c[:item]} W/COUPON",
    :price => rounded_unit_price,
    :count => c[:num]
  }
end

def apply_coupon_to_cart(matching_item, coupon, cart)
  matching_item[:count] -= coupon[:num]
  item_with_coupon = mk_coupon_hash(coupon)
  item_with_coupon[:clearance] = matching_item[:clearance]
  cart << item_with_coupon
end

def apply_coupons(cart, coupons)
  # Consult README for inputs and outputs
  #cart is array of item hashes
  #coupons is a collection of coupon hashes
  # [coupons[i][:item], "W/COUPON"].join(' ') --> method
  # REMEMBER: This method **should** update cart
  i = 0
  while i < coupons.length do
    coupon = coupons[i]
    item_with_coupon = find_item_by_name_in_collection(coupon[:item],cart)

    if !!item_with_coupon && item_with_coupon[:count] >= coupon[:num]
      apply_coupon_to_cart(item_with_coupon, coupon, cart)
    end
    i += 1
  end
  cart

end

def apply_clearance(cart)
  # Consult README for inputs and outputs
  i = 0
  while i < cart.length do
    item = cart[i]
    if item[:clearance]
      discounted_price = (item[:price] * (1 - 0.2)).round(2)
      item[:price] = discounted_price
    end
    i +=1
  end
  cart
  # REMEMBER: This method **should** update cart
end

def checkout(cart, coupons)
  # Consult README for inputs and outputs
  #
  ccart = consolidate_cart(cart)
  couponed_cart = apply_coupons(ccart, coupons)
  final_cart = apply_clearance(ccart)

  grand_total = 0
  i = 0
  while i < final_cart.length do
    grand_total += (final_cart[i][:price] * final_cart[i][:count])
    i += 1
  end

  if grand_total > 100
    grand_total -= (grand_total * 0.10)
  end
  grand_total
  # This method should call
  # * consolidate_cart
  # * apply_coupons
  # * apply_clearance
  #
  # BEFORE it begins the work of calculating the total (or else you might have
  # some irritated customers
end
