def find_item_by_name_in_collection(name, collection)
  counter = 0 
  while counter < collection.length do 
    if collection[counter][:item] == name #if the item in the collection is == the name passed in
      return collection[counter] # do this
    end
    counter += 1
  end
  nil #if item is not in the cart returns nil
end


def consolidate_cart(cart)
  new_cart = []
  counter = 0 
  while counter < cart.length do 
    new_cart_item = find_item_by_name_in_collection(cart[counter][:item], new_cart)
    if new_cart_item != nil #if the item exists
      new_cart_item[:count] += 1 #increment the count by 1
    else #if the item doesnt exist
      new_cart_item = { #create the item 
          :item => cart[counter][:item],
          :price => cart[counter][:price],
          :clearance => cart[counter][:clearance],
          :count => 1 #and set the count to one. This is an added key.
      }
      new_cart << new_cart_item #add the new item to the array
    end
   counter += 1 #increment the count to process the loop for each variable
  end
 new_cart #return the updated cart
end
  # Consult README for inputs and outputs
  #
  # REMEMBER: This returns a new Array that represents the cart. Don't merely
  # change `cart` (i.e. mutate) it. It's easier to return a new thing.

def apply_coupons(cart, coupons)
  counter = 0 
  while counter < coupons.length
  cart_item = find_item_by_name_in_collection(coupons[counter][:item], cart)
  couponed_item_name = "#{coupons[counter][:item]} W/COUPON"
  cart_item_with_coupon = find_item_by_name_in_collection(couponed_item_name, cart)
  if cart_item && cart_item[:count] >= coupons[counter][:num]
    if cart_item_with_coupon
      cart_item_with_coupon[:count] += coupons[counter][:num]
      cart_item[:count] -= coupons[counter][:num]
    else
      cart_item_with_coupon = {
        :item => couponed_item_name,
        :price => coupons[counter][:cost] / coupons[counter][:num],
        :count => coupons[counter][:num],
        :clearance => cart_item[:clearance]
      }
      cart << cart_item_with_coupon
      cart_item[:count] -= coupons[counter][:num]
    end
   end
  counter += 1
 end
 cart
end 
  # REMEMBER: This method **should** update cart


def apply_clearance(cart)
  counter = 0 
  while counter < cart.length do
    if cart[counter][:clearance]
      cart[counter][:price] = (cart[counter][:price] - (cart[counter][:price] * 0.20)).round(2)
    end
   counter += 1
  end
 cart
end
  # Consult README for inputs and outputs
  #
  # REMEMBER: This method **should** update cart


def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  couponed_cart = apply_coupons(consolidated_cart, coupons)
  final_cart = apply_clearance(couponed_cart)
  
  total = 0
  counter = 0
  while counter < final_cart.length do 
    total += final_cart[counter][:price] * final_cart[counter][:count]
  counter += 1
  end
  if total > 100 
    total -= (total * 0.10)
  end
 total
end
  # Consult README for inputs and outputs
  #
  # This method should call
  # * consolidate_cart
  # * apply_coupons
  # * apply_clearance
  #
  # BEFORE it begins the work of calculating the total (or else you might have
  # some irritated customers

