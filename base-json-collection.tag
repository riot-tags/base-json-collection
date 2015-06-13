require('../base-ajax-json/base-ajax-json');
<base-remote-json-collection>
    <base-ajax-json name="ajaxElement" query={query} onsuccess={_success} onerror={_fail} type={type} baseurl={baseurl}></base-ajax-json>
    <script>
    /* global opts */
    'use strict';
        var self = this;
        this._currentPage = 0;
        var goEvent = new Event('go');
        this.query = opts.query;
        this.success = opts.success;
        this.fail = opts.fail;
        this.type = opts.type;
        this.baseurl = opts.baseurl || 'http://jsonplaceholder.typicode.com/posts';
        this.responseWrapper = opts.responsewrapper || null;
        this.responseItemWrapper = opts.ersponseitemwrapper || null;
        this.idproperty = opts.idproperty || 'id';
        this.decodeResult = opts.decodeResult || null;
        this.collection = {};
        this._collection = [];
        this.paging = opts.paging ||  function(){
            return {page:self._currentPage++};
        };

        /** Fetch a collection by ajax and store the collection.
         *
         * */
        this.query = {
            //userId:1
        };

        this._success = function(response){
            console.log('successful');
            console.log();
            response = response.detail || response; //IF it is the custom event we receive then set it to detail, otherwise it is the response.
            var newitems = {};

            var unwrappedItem;
            var unwrappedResponse = self.responseWrapper ? response[self.responseWrapper] : response;

            unwrappedResponse.forEach(function(item){
                //If a itemwrapper property is supplied then get the inner object.
                unwrappedItem = self.responseItemWrapper ? item[self.responseItemWrapper] : item;

                //Check if it laready is in the collection. This is only to be able to emit a change event.
                if (self.collection[unwrappedItem[self.idproperty]]){
                    //Update item in the collection.
                    console.log('update item');
                }else{
                    //New item for the collection.
                    console.log('add item');
                    self._collection.push(unwrappedItem);
                    newitems[unwrappedItem[self.idproperty]] = unwrappedItem;
                }
                self.collection[unwrappedItem[self.idproperty]] = unwrappedItem;

            });
            var changedEvent = new CustomEvent('collection-changed', {detail:{collection:self._collection, newitems:newitems}})
            //Did we get asuplied callback?
            self.root.dispatchEvent(changedEvent);
            if (self.success){
                self.success(self.collection,newitems);
            }

        }

        this._fail = function(status,response){
            console.log('failed');
            self.fail(status, response);
        };

        this.on('go', function(){
            //self.ajaxElement.go();
        });

        this.on('mount', function(){
                self.ajaxElement.addEventListener('response-success', self._success);

            setTimeout(function(){
                //self.ajaxElement.go();
                self.ajaxElement.dispatchEvent(goEvent);
               //self.root.go = self.ajaxElement.go;
            },1500);

        });
    </script>
</base-remote-json-collection>