require 'pp'

def find_item_by_name_in_collection(name, collection)
  # Implement me first!
  #
  # Consult README for inputs and outputs
#

find_name = collection.find {|x| x[:item] == name}
if collection.length == 0 || find_name == nil
  return  nil
else
  return find_name
end
end


def consolidate_cart(cart)
  # Consult README for inputs and outputs
  #
  # REMEMBER: This returns a new Array that represents the cart. Don't merely
  # change `cart` (i.e. mutate) it. It's easier to return a new thing.
z = 0
new_array = []

  while z < cart.length do
    find_by_item = find_item_by_name_in_collection(cart[z][:item], new_array)
    if new_array.length == 0 || find_by_item == nil
      new_array << cart[z]

      add_count = new_array.find{|x| x[:item] == cart[z][:item]}
      add_count[:count] = 1
  else
      add_count[:count] += 1
    end
    z += 1
  end
   new_array
end


def apply_coupons(cart, coupons)
  # Consult README for inputs and outputs
  #
  # REMEMBER: This method **should** update cart
  result = []
  z = 0
  while z < cart.length do
    find_by_item = find_item_by_name_in_collection(cart[z][:item], coupons)
    if find_by_item != nil
      result << cart[z]
      item_clone = cart[z].clone
      coupons_num = coupons.find {|x| x[:item] == cart[z][:item]}
      cart_count = result.find {|y| y[:item] == cart[z][:item]}

      item_clone[:item] = "#{cart[z][:item]} W/COUPON"
      item_clone[:price] = coupons_num[:cost]/coupons_num[:num]

        if coupons_num[:num] > cart[z][:count]
          final_count = coupons_num[:num] - cart[z][:count]
            item_clone[:count] = final_count
            cart_count[:count] = [final_count, 0].max
          elsif coupons_num[:num] <= cart[z][:count]
            item_clone[:count] = coupons_num[:num]
            cart_count[:count] = cart[z][:count] - coupons_num[:num]
        end
      result << item_clone
    elsif find_by_item == nil
       result << cart[z]
    end
    z += 1
    end
    result
end

def apply_clearance(cart)
  # Consult README for inputs and outputs
  #
  # REMEMBER: This method **should** update cart
  result = []
  i = 0
  while i < cart.length do
    result << cart[i]
    if result[i][:clearance] == true
      result[i][:price] = result[i][:price] - (result[i][:price] * 0.2).round(2)
  end
  i += 1
end
  result
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
  result = cart.clone
  consolidated_cart = consolidate_cart(result)
  coupon_applied_cart = apply_coupons(consolidated_cart, coupons)
  clearance_applied_cart = apply_clearance(coupon_applied_cart)
  clearance_applied_cart
  i = 0
  grand_total = 0

  while i < clearance_applied_cart.length do
  total = clearance_applied_cart[i][:price] * clearance_applied_cart[i][:count]
    i += 1
    grand_total += total.round(2)
  end
return grand_total > 100 ? grand_total - (grand_total  * 0.1 ): grand_total
end
