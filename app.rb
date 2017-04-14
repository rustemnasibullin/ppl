require 'rubygems'
require 'sinatra'
require "#{File.dirname(__FILE__)}/ppl"
set :port, 5000

init_ppl()

get '/ppl' do
  '<html><body><center> <br/><br/> <h1>Purchase Platform Demonstration By Rustem Nasibullin.</h1>  <br/><br/><br/><br/>   <a href="ppl/loginAsBob"> Login as Bob</a>   <br/>  <a href="ppl/loginAsJohn"> Login as John</a>   </center></body>   </html>'
end

get '/ppl/loginAsBob' do
    File.read(File.join('public', 'loginAsBob.html'))
end

get '/ppl/loginAsJohn' do
    File.read(File.join('public', 'loginAsJohn.html'))
end

post '/ppl' do
   $IN=request.body.read   
   process_in();
   @result=$OUT;
   if (@result == nil)
   @result='{"status":"JobIsDone"}';
   elsif
   @result='{"result":"'+$OUT.to_s()+'"}';
   end;
   $LOG.info(' RESULT4 => '+@result.to_s());
   return @result;
end

get '/ppl/getprice' do
   cid = params[:cid]
   pid = params[:pid]
   $IN='{"CMD":"GET_PRICE_OF_THE_PRODUCT","USER":'+cid+',"PRODUCT":'+pid+'}';
   process_in();
   @result=$OUT;
   if ($OUT == nil)
   @prod=get_product(pid.to_i)
   $LOG.info(pid.to_s()+' RESULT6 => '+@prod.to_s());
   @result=@prod["PNAME"] + '  No Available';
   elsif
   @result='{"result":"'+$OUT.to_s()+'"}';
   end;
   return @result;
end
