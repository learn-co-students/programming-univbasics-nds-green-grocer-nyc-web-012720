def find_item_by_name_in_collection(name, collection)
count=0
  while count < collection.size do 
    if collection[count][:item] === name
      return collection[count]
    end
    count+=1
  end
   nil
 end

def consolidate_cart(cart)
  array=[]
  count=0
  while count<cart.length do 
    #new_cart_array=[:count]
    new_cart_array=find_item_by_name_in_collection(cart[count][:item],array)
    if new_cart_array
      new_cart_array[:count]+=1
    else
      new_cart_array=cart[count]
      # add :count and set equal to 1 in cart array
      new_cart_array[:count]=1
      # add it to the new array from new_cart_array(old array)
      array.push(new_cart_array)
  end
  count+=1
end
array
end

def apply_coupons(cart, coupons)
  counter =0
  while counter<coupons.size do 
    cart_item=find_item_by_name_in_collection(coupons[counter][:item],cart)
   coupon_name="#{coupons[counter][:item]} W/COUPON"
   cart_item_with_coupon=find_item_by_name_in_collection(coupon_name,cart)
   if cart_item && cart_item[:count]>=coupons[counter][:num]
     if cart_item_with_coupon
       cart_item_with_coupon[:count]+=coupons[counter][:num]
       cart_item[:count]-=coupons[counter][:num]
     else
       cart_item_with_coupon={
         :item => coupon_name,
         :price => coupons[counter][:cost]/coupons[counter][:num],
         :clearance =>cart_item[:clearance],
         :count => coupons[counter][:num]
       }
       cart << cart_item_with_coupon
       
       cart_item[:count]-=coupons[counter][:num]
   end
  end
  counter +=1
  end
cart
end

def apply_clearance(cart)
  count=0
  while count<cart.size do 
    if cart[count][:clearance] === true
      cart[count][:price]*=0.8
      cart[count][:price].round(2)
    end
    count +=1
end
cart
end

def checkout(cart, coupons)
  consolidate_cart=consolidate_cart(cart)
  total_coupons=apply_coupons(consolidate_cart,coupons)
  final_clearance=apply_clearance(total_coupons)
  
  sum_of_cart=0
  counter=0
  while counter<final_clearance.length do 
  sum_of_cart+=final_clearance[counter][:price]*final_clearance[counter][:count]
  
  counter+=1
  end
  if sum_of_cart > 100
    sum_of_cart-=(sum_of_cart*0.1)
  end
sum_of_cart.round(2)
  
end
