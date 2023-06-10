
class ApiServices{
  ApiServices._();
    static  const BASEURL = "http://192.168.10.5:1999/";
//    static const SOCKET_RECENT_ORDER_URL = "${BASEURL}recentorder";

   static const login = "${BASEURL}admin/login";  

   static const getRestaurants = "${BASEURL}admin/restaurant/get";
   static const updateRestaurants = "${BASEURL}admin/restaurant/update";
static const addRestaurants = "${BASEURL}admin/restaurant/add";
static const deleteRestaurants = "${BASEURL}admin/restaurant/delete";

   static const menus_list = "${BASEURL}admin/restaurant/dishes/menus/";
   static const dishes_list = "${BASEURL}admin/restaurant/dishes/";
     static const update_menu_dishes = "${BASEURL}admin/restaurant/dishes/menuanddishesstatus";
    static const update_dishes = "${BASEURL}admin/restaurant/dishes/update_dish";
     static const add_variant = "${BASEURL}admin/restaurant/dishes/addVariant"; 
     static const update_variant = "${BASEURL}admin/restaurant/dishes/updateVariant"; 
   static const add_variant_item = "${BASEURL}admin/restaurant/dishes/addVariantitem"; 
  
  static const update_variant_item = "${BASEURL}admin/restaurant/dishes/updateVariantitem"; 
  
     static const delete_variant = "${BASEURL}admin/restaurant/dishes/deleteVariant"; 
  
     static const delete_variant_item = "${BASEURL}admin/restaurant/dishes/deleteVariantitem"; 
  
   static const add_dish = "${BASEURL}admin/restaurant/dishes/addDish"; 
   
   static const delete_dish = "${BASEURL}admin/restaurant/dishes/deletedish"; 

   static const updatemenu = "${BASEURL}admin/restaurant/dishes/updatemenu"; 

    static const add_menu = "${BASEURL}admin/restaurant/dishes/menus/";
   static const update_menus_list = "${BASEURL}admin/restaurant/dishes/menus";

   static const dishes_reports = "${BASEURL}admin/reports/dishes";
   static const restaurant_reports = "${BASEURL}admin/reports/restaurants";

   static const office_location = "${BASEURL}admin/officelocation";
   
   static const delivery_charges = "${BASEURL}admin/deliverycharges";

   static const get_categories = "${BASEURL}admin/category";

   static const get_orders = "${BASEURL}admin/orders/";

   static const get_dashboard = "${BASEURL}admin/dashboard";

   static const grocery_dashboard = "${BASEURL}admin/dashboard/grocery";

   static const search_dish = "${BASEURL}admin/restaurant/dish/search?search=";


   static const home_categories = "${BASEURL}admin/category/home";


   static const search_categories = "${BASEURL}admin/category/search?search=";

   static const home_tags = "${BASEURL}admin/tags/home";


   static const search_tags= "${BASEURL}admin/tags/search?search=";

static const get_tags = "${BASEURL}admin/tags";

static const deliverypersons = "${BASEURL}admin/deliverypersons";

static const toprestaurants = "${BASEURL}admin/restaurant/toprestaurants";

static const searchrestaurants = "${BASEURL}admin/restaurant/search?search=";




  static const getGrocery = "${BASEURL}admin/grocery/get";
  
  static const addGrocery = "${BASEURL}admin/grocery/add";
 
 
  static const GroceryUpdateStatus = "${BASEURL}admin/grocery/status";
  
   static const search_grocery_categories = "${BASEURL}admin/grocery/search/categories?search=";
   static const search_grocery_types = "${BASEURL}admin/grocery/search/types?search=";
   static const search_grocery_brands = "${BASEURL}admin/grocery/search/brands?search=";
 static const search_grocery_tags = "${BASEURL}admin/grocery/search/tags?search=";

   static const search_grocery_produts = "${BASEURL}admin/grocery/search/product?search=";

   
  static const add_grocery_variant = "${BASEURL}admin/grocery/addVariant";
  static const update_grocery_variant = "${BASEURL}admin/grocery/updateVariant";
  static const delete_grocery_variant = "${BASEURL}admin/grocery/deleteVariant";
  

  static const add_grocery_variant_item = "${BASEURL}admin/grocery/addVariantItem";
  static const update_grocery_variant_item = "${BASEURL}admin/grocery/updateVariantItem";
  
  static const delete_grocery_variant_item = "${BASEURL}admin/grocery/deleteVariantItem";


  
  static const Edit_product = "${BASEURL}admin/grocery/editProduct";
  



  static const get_grocery_categories = "${BASEURL}admin/grocery/category";
  
  
  static const get_grocery_tag = "${BASEURL}admin/grocery/tag";
  
  static const get_grocery_brand = "${BASEURL}admin/grocery/brand";

  
  static const get_grocery_type = "${BASEURL}admin/grocery/type";

  static const grocery_home_categories = "${BASEURL}admin/grocery/category/home";

  
  static const grocery_home_tags = "${BASEURL}admin/grocery/tag/home";
  
   }