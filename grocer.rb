def find_item_by_name_in_collection(name, collection)
  i = 0 
  while i < collection.length do 
    item_name = collection[i][:item]
    if item_name == name
      return collection[i]
    else
      nil
    end
    i+=1 
  end 
  nil
end


def consolidate_cart(cart)
  result = []
  result << cart[0]
  result[0][:count] = 1 
  
  i = 1 
  while i < cart.length do 
    item_name = cart[i][:item]
    whole_item = cart[i]
    duplicates = find_item_by_name_in_collection(item_name, result)
    if duplicates 
      duplicates[:count] += 1 
    else 
      whole_item[:count] = 1 
      result << whole_item
    end 
    i+=1   
  end 

  result
end


def apply_coupons(cart, coupons)
  new_cart = []
  
  i = 0 
  while i < cart.length do 
    new_cart << cart[i]
    i+=1 
  end 

  j = 0 
  while j < coupons.length do 
    coupon_item = coupons[j]
    coupon_item_name = coupon_item[:item]
    k = 0 
    while k < new_cart.length do 
      cart_item = new_cart[k]
      cart_item_name = cart_item[:item]
      if coupon_item_name == cart_item_name
        difference = (cart_item[:count] - coupon_item[:num])
        if difference >= 0 
          new_item = {
            :item => coupon_item_name + " W/COUPON", 
            :price => coupon_item[:cost] / coupon_item[:num], 
            :clearance => cart_item[:clearance], 
            :count => coupon_item[:num], 
          }
          cart_item[:count] = difference
          new_cart << new_item
        end 
      end 
      k+=1 
    end 
    j+=1 
  end 

  new_cart

end



def apply_clearance(cart)

  result = [] 
  i = 0 
  while i < cart.length do 
    item_name = cart[i][:item]
    if find_item_by_name_in_collection(item_name, result)
      #NOTHING 
    else 
      result << cart[i]
    end 
    i+=1 
  end 
  
  j = 0 
  while j < result.length do
    price = result[j][:price]
    if result[j][:clearance] == true
      new_price = (price * 0.20).round(2)
      result[j][:price] = price - new_price
    end
    j+=1 
  end 
  
  result
  
end


def checkout(cart, coupons)
  cons_cart = consolidate_cart(cart)
  
  valid_coupon = []
  valid = false
  i = 0 
    while i < coupons.length do
      coupon_item = coupons[i][:item]
      check_coupon = coupons[i][:num]
      j = 0 
      while j < cons_cart.length do 
        consolidated_item = cons_cart[j][:item]
        check_item = cons_cart[j][:count]
        if coupon_item == consolidated_item && (check_item - check_coupon) >= 0 
           valid = true
        end
        j+=1 
      end 
      if valid 
      valid_coupon << coupons[i]
    end
    i+=1 
  end 
    if valid_coupon.length >= 1 
        coupons_applied = apply_coupons(cons_cart, coupons = valid_coupon)
        checkout_cart = apply_clearance(coupons_applied)
      else 
        checkout_cart = apply_clearance(cons_cart)
      end 
  
  i = 0 
  subtotal = 0 
  total = 0 
  while i < checkout_cart.length do 
    subtotal = checkout_cart[i][:price] * checkout_cart[i][:count]
    total += subtotal
    i+=1 
  end 
  if total > 100
    total = total - (total * 0.10)
  end 
  total.round(2)
end


