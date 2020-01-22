require 'pry'
def find_item_by_name_in_collection(name, collection)
 
  # Implement me first!
  #
  # Consult README for inputs and outputs
  
  i = 0
  while i < collection.length do 
    if name === collection[i][:item]
      return collection[i]
    else
      nil
    end
    i += 1
  end
end


def consolidate_cart(cart)
  
  # Consult README for inputs and outputs
  #
  # REMEMBER: This returns a new Array that represents the cart. Don't merely
  # change `cart` (i.e. mutate) it. It's easier to return a new thing.
  
  array = []
  i = 0
  while i < cart.length do
    item_key = cart[i][:item]
    new_item = find_item_by_name_in_collection(item_key,array)
    if new_item 
      new_item[:count] += 1
    else
      new_item = {
        :item => cart[i][:item],
        :price => cart[i][:price],
        :clearance => cart[i][:clearance],
        :count => 1
      }
      array << new_item
    end
    i += 1
  end
  array
end


def apply_coupons(cart, coupons)
  # Consult README for inputs and outputs
  #
  # REMEMBER: This method **should** update cart
  
 i = 0
 while i < coupons.length do
   
   coupon_item = coupons[i][:item]
   coupon_num = coupons[i][:num]
   
   cart_item = find_item_by_name_in_collection(coupon_item, cart)
   couponed_item_name = "#{coupon_item} W/COUPON"
   cart_item_with_coupon = find_item_by_name_in_collection(couponed_item_name, cart)
  
  if cart_item && cart_item[:count] >= coupon_num 
    
     if cart_item_with_coupon
       cart_item_with_coupon[:count] += coupon_num 
       cart_item[:count] -= coupon_num 
     else
       cart_item_with_coupon = {
         :item => couponed_item_name,
         :price => coupons[i][:cost] / coupon_num,
         :clearance => cart_item[:clearance],
         :count => coupon_num,
       }
       cart << cart_item_with_coupon
       cart_item[:count] -= coupon_num
     end
   end
   i += 1
 end
 cart
end


def apply_clearance(cart)
  # Consult README for inputs and outputs
  #
  # REMEMBER: This method **should** update cart
  
  i = 0
  while i < cart.length do
    if cart[i][:clearance]
      cart[i][:price]= (cart[i][:price] - (cart[i][:price] * 0.20)).round(2)
    end
    i += 1
  end
  cart
end


def checkout(cart, coupons)
  # Consult README for inputs and outputs
  #
  # This method should call
  # * consolidate_cart
  # * apply_coupons
  # * apply_clearance
  #
  # BEFORE it begins the work of calculating the total (or else you might have
  # some irritated customers
  
  consolidated_cart = consolidate_cart(cart)
  couponed_cart = apply_coupons(consolidated_cart, coupons)
  final_cart = apply_clearance(couponed_cart)
  
  total = 0
  i = 0
  while i < final_cart.length do
    total += final_cart[i][:price] * final_cart[i][:count]
    i += 1
  end
  if total > 100
    total -= (total * 0.10)
  end
  total
end
