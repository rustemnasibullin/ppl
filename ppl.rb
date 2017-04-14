require 'json'                      
require 'date'

$IN=nil;        #
$OUT=nil;       #
$CACHE=nil;     #
$STORAGE=nil;   #
$LOG=nil;       #


class CACHEMOCK

def initialize 
    @tblSet={"PRODUCT"=>{},"USER"=>{},"VENDOR"=>{},"CONTRACT"=>{},"PRICE"=>{}};
end;


def put(entity,key,attributes)
    tbl=@tblSet[entity];
    if (tbl != nil)
    tbl[key]=attributes; 
    end 
end;

def get(entity,key) 
    tbl=@tblSet[entity];
    if (tbl != nil)
    return tbl[key]; 
    end
    nil; 
end;

def get_table(entity) 
    tbl=@tblSet[entity];
    return tbl; 
end;

end;

class STORAGEMOCK

def initialize 
    @tblSet={"PRODUCT"=>{},"USER"=>{},"VENDOR"=>{},"CONTRACT"=>{},"PRICE"=>{}};
end;

def get_table(entity) 
    tbl=@tblSet[entity];
    return tbl; 
end;

def put(entity,key,attributes) 
    tbl=@tblSet[entity];
    if (tbl != nil)
    tbl[key]=attributes; 
    end 
end;

def get(entity,key) 
    tbl=@tblSet[entity];
    if (tbl != nil)
    return tbl[key]; 
    end
    nil; 
end;

end;

class LOGMOCK

def info(data) 
puts data;
end;

end;


# @todo
def get_orders_by_product(pid)
orders={}
orders
end


# @DONE
def clear_price_for_contract(contract)
vid=contract["VID"];
cid=contract["CID"];
prices=$CACHE.get("PRICE",vid);
if (prices==nil)
prices=$STORAGE.get("PRICE",vid);
end

if (prices!=nil)
    prices.each do |key, value|
    value.delete(cid) 
end
end

end

# @DONE
def get_prices_for_the_product(pid)
product=get_product(pid)

$LOG.info('get_prices_for_the_product: '+pid.to_s()+' - '+product.to_s());


vid=product["VID"];

$LOG.info('get_prices_for_the_product1: '+vid.to_s());

prices=$CACHE.get("PRICE",vid);
$LOG.info('get_prices_for_the_product2: '+prices.to_s());

if (prices==nil)
prices=$STORAGE.get("PRICE",vid);
if (prices!=nil)
$CACHE.put("PRICE",vid,prices);
end
end

$LOG.info('get_prices_for_the_product ..........................: '+prices.to_s());

if (prices==nil)
@result=nil
elsif
@result=prices[pid]
end

return @result 

end  


def put_price_for_the_product(cid,pid,price)
    product=get_product(pid)
    vid=product["VID"];
    $LOG.info('0. put_price_for_the_product ..........................: '+vid.to_s());
    prices=$CACHE.get("PRICE",vid);
    
    $LOG.info('1. put_price_for_the_product ..........................: '+prices.to_s());

    if (prices==nil)

    prices=$STORAGE.get("PRICE",vid);
    if (prices!=nil)
    $LOG.info('2. put_price_for_the_product ..........................: '+prices.to_s());

    pricebids=prices[pid];
    pricebids[cid]=PRICE
    $CACHE.put("PRICE",vid,prices);
    $STORAGE.put("PRICE",vid,prices);
    else
    $LOG.info('3. put_price_for_the_product ..........................: '+prices.to_s());

    prices={pid=>{cid=>price}}

    $LOG.info('3.1. put_price_for_the_product ..........................: '+prices.to_s());

    $CACHE.put("PRICE",vid,prices);
    $STORAGE.put("PRICE",vid,prices);
    end

    else
    $LOG.info('4. put_price_for_the_product ..........................: '+pid.to_s());

    pricebids=prices[pid];
    $LOG.info('4. put_price_for_the_product ..........................: '+pricebids.to_s());

    if (pricebids!=nil) 
    pricebids[cid]=price;
    else
    pricebids={cid=>price};
    prices[pid]=pricebids;
    $LOG.info('5. put_price_for_the_product ..........................: '+prices.to_s());
    end
    $CACHE.put("PRICE",vid,prices);
    $STORAGE.put("PRICE",vid,prices);

    end


end



# @DONE
def get_contracts_by_vendor(vid)
@contracts=nil
@contracts=$CACHE.get("CONTRACT",vid);
if (@contracts == nil)
    @contracts={};
    $CACHE.put("CONTRACT",@vid,@contracts)
    $STORAGE.put("CONTRACT",@vid,@contracts)
end
@contracts
end


# @DONE
def put_contract_for_vendor(u,c)

    @vid=c["VID"];
    @contracts=get_contracts_by_vendor(@vid);
    @cid=u["CID"];
    c["CID"]=@cid;
    @contracts[@cid]=c;
    $CACHE.put("CONTRACT",@vid,@contracts)
    $STORAGE.put("CONTRACT",@vid,@contracts)

end


# @DONE
def get_vendor(vid)
@vendor=nil

@vendor=$CACHE.get("VENDOR",vid);

if (@vendor==nil)
@vendor=$STORAGE.get("VENDOR",vid);

if (@vendor!=nil)
$CACHE.get("VENDOR",vid,@vendor);
end

end  

@vendor
end


# @DONE
def get_product(pid)
@product=nil


$LOG.info($CACHE.get_table("PRODUCT").to_s());
$LOG.info(pid.to_s()+ '   get_the_product .......................... ');

@product=$CACHE.get("PRODUCT",pid);

$LOG.info(pid.to_s()+ '   get_the_product ..........................: '+@product.to_s());

if (@product==nil)
@product=$STORAGE.get("PRODUCT",pid);
$LOG.info(pid.to_s()+ '   get_the_product ..........................: '+@product.to_s());
if (@product!=nil)
$LOG.info(pid.to_s()+ '   get_the_product ..........................: '+@product.to_s());
$CACHE.put("PRODUCT",pid,@product);
end

end  

$LOG.info(pid.to_s()+ '   get_the_product ..........................: '+@product.to_s());
@product

end


def put_product(p) 

@PID=p["PID"];
@product=$CACHE.get("PRODUCT",@PID)

if (@product==nil)
@product=$STORAGE.get("PRODUCT",@PID)
if (@product==nil)
    $STORAGE.put("PRODUCT",@PID,p)
    @product=$STORAGE.get("PRODUCT",@PID)
end

# put product to cache
if (@product!=nil)
    $CACHE.put("PRODUCT",@PID,@product)
end

end
end


##  UC-1 Put nformation about  vendors and products of ones 
def put_vendor_contract(q)
$LOG.info('put_vendor_contract');

@VENDOR=q["VENDOR"];
@PRODUCT=q["PRODUCT"];
@VID=@VENDOR["VID"];
@PRODUCT["VID"]=@VID;

# CHECK IN CACHE VENDOR
@vendor=$CACHE.get("VENDOR",@VID)
# IF NOT IN CACHE CHECK IN STORE 
if (@vendor == nil) 
# IF IN STORAGE RENEW IN CACHE
@vendor=$STORAGE.get("VENDOR",@VID)
if (@vendor == nil) 
# IF NOT IN STORAGE - ADD  NEW VENDOR AND PRODUCT OF ONE 
$STORAGE.put("VENDOR",@VID,@VENDOR)
@vendor=$STORAGE.get("VENDOR",@VID)
end


# AND IF OK - PUT TO THE CACHE
if (@vendor != nil) 
$CACHE.put("VENDOR",@VID,@vendor)
end

end


if (@vendor != nil)  # IF VENDOR OK  PUT NEW PRODUCT !!!!
    put_product(@PRODUCT)
end


end

##  UC-2 Put information about Users and contracts with Vendors 
def put_contract(q)
$LOG.info('put_contract');
@USER=q["USER"];
@CONTRACT=q["CONTRACT"];
@CID=@USER["CID"];

@user=$CACHE.get("USER",@CID)
$LOG.info(@USER.to_s()+' - '+@CONTRACT.to_s());

if (@user == nil) 
    @user=$STORAGE.get("USER",@CID)
    if (@user == nil) 
    $STORAGE.put("USER",@CID,@USER)
    @user=$STORAGE.get("USER",@CID)
    end
    if (@user != nil)
    @user=$CACHE.put("USER",@CID,@user)  ## new user added
    end 
end

## add new contract with vendor

if (@CONTRACT!=nil)
@VID=@CONTRACT["VID"];
@vendor=get_vendor(@VID)
if (@vendor != nil)
##  vendor exists - OK!!!
@contracts=get_contracts_by_vendor(@VID);

$LOG.info(@VID.to_s()+' get_contracts_by_vendor '+@contracts.to_s());


@contract=@contracts[@CID]

$LOG.info(@CID.to_s()+' get_contract '+@contract.to_s());

if (@contract!=nil)
clear_price_for_contract(@contract)
end
put_contract_for_vendor(@USER, @CONTRACT)
end 
end

end



##  UC-3 Put Special prices for corresponding contracts 
def put_new_pricebid(q)
$LOG.info('put_new_pricebid');
@CID=q["USER"];
@PID=q["PRODUCT"];
@PRICE=q["PRICE"];


@product=get_product(@PID)
$LOG.info('put_new_pricebid:  '+@PID.to_s());
$LOG.info('put_new_pricebid:  '+@PRICE.to_s());
$LOG.info('put_new_pricebid:  '+@CID.to_s());

$LOG.info('put_new_pricebid:  '+@product.to_s());

if (@product != nil)

@VID=@product["VID"]
@contracts=get_contracts_by_vendor(@VID);
@contract=@contracts[@CID]
$LOG.info('put_new_pricebid:  '+@contract.to_s());

if (@contract!=nil)
# CONTRACT EXISTS - IT'S OK TO PUT PRICE 
$LOG.info('put_new_pricebid:  '+@prices.to_s());
put_price_for_the_product(@CID,@PID,@PRICE)

end
end

end



##  UC-4 Put Special pricies for corresponding contracts 
def get_price_of_the_product(q)
@pricebid=nil
$LOG.info('get_price_of_the_product');
@CID=q["USER"];
@PID=q["PRODUCT"];
@product=get_product(@PID)

$LOG.info(@PID.to_s()+' - '+@product.to_s());

if (@product != nil)
@pricebid=@product["DEFPRICE"]
@vid=@product["VID"]

$LOG.info(@vid.to_s()+' - '+@pricebid.to_s());

@contracts=get_contracts_by_vendor(@vid);   # GET all contracts of vendor
@contract=@contracts[@CID]

$LOG.info(' contract => '+@contract.to_s());

if (@contract!=nil)     # User has contract with vendor
# CONTRACT EXISTS - IT'S OK TO PUT PRICE 
@prices=get_prices_for_the_product(@PID)  
@pricebid=nil;
if (@prices != nil)
@pricebid0=@prices[@CID]
if (@pricebid0 != nil)
@pricebid=@pricebid0
end
end
end


    
end

$LOG.info(' RESULT => '+@pricebid.to_s());

@pricebid
end


##  UC-5 Make Order for Product 
def order_product(q)
$LOG.info('order_product');
@CID=q["USER"];
@PID=q["PRODUCT"];
@orders=get_orders_by_product(@PID)
@orders[@CID]=DateTime.now 
end


def process_in  
@Q=JSON.parse($IN);  # returns a hash
cmd = @Q['CMD'];
$OUT=nil;

if 'PUT_VENDOR_CONTRACT' == cmd then
   put_vendor_contract(@Q)
elsif 'PUT_CONTRACT' == cmd then
   put_contract(@Q)
elsif 'PUT_NEW_PRICE_BID' == cmd then
   put_new_pricebid(@Q)
elsif 'GET_PRICE_OF_THE_PRODUCT' == cmd then

   $OUT=get_price_of_the_product(@Q)
   $LOG.info(' RESULT2 => '+$OUT.to_s());

elsif 'ORDER_PRODUCT' == cmd then
   order_product(@Q)
end

end


# -- JSON samples

def init_ppl

$CACHE=CACHEMOCK.new;
$STORAGE=STORAGEMOCK.new;
$LOG=LOGMOCK.new;

end

def test
 
$CACHE=CACHEMOCK.new;
$STORAGE=STORAGEMOCK.new;
$LOG=LOGMOCK.new;

@MSG1='{"CMD":"PUT_VENDOR_CONTRACT","VENDOR":{"VID":2001,"VNAME":"BOEING"},"PRODUCT":{"PID":3001,"PNAME":"BOEING-747-300","DEFPRICE":2000.0}}';
@MSG2='{"CMD":"PUT_CONTRACT","USER":{"CID":1001,"CNAME":"BOB"},"CONTRACT":{"ID":4001,"VID":2001,"TYPEOFPAYMENTTERM":0}}';  #0-Payment immidiatly, 1+ -shipment in n-days  
@MSG3='{"CMD":"PUT_NEW_PRICE_BID","USER":1001,"PRODUCT":3001,"PRICE":1000.0}';
@MSG4='{"CMD":"GET_PRICE_OF_THE_PRODUCT","USER":1001,"PRODUCT":3001}';
@MSG5='{"CMD":"ORDER_PRODUCT","USER":1001,"PRODUCT":3001}';

$IN=@MSG1;
process_in();

$IN=@MSG2;
process_in();

$IN=@MSG3;
process_in();

$IN=@MSG4;
process_in();

$IN=@MSG5;
process_in();

end

##   main block 
 
##   puts ' START INTERNAL TEST ';

##   test();






