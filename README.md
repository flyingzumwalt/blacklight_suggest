# BlacklightSuggest - autocomplete functionality for blacklight

Rails engine that enables javascript-based autocomplete in the search query box and adds core support for spelling & completion suggesters.

## Note about Solr Compatibility

This gem is based on code that worked with Solr 4.x, but the gem itself has only been tested with Solr 5.

* defines a SuggestionController
* defines a '/suggest' API endpoint on your application

## Installation

Add this line to your blacklight application's Gemfile:

```ruby
gem 'blacklight_suggest'
```

And then execute:

    $ bundle

## Usage

This gem is meant to be used as an add-on to Blacklight. It adds a 'suggestions' endpoint 
at /suggestions.  To change this route, add a line like this to your config/routes.rb:

```ruby
  get '/suggest', to: 'suggestions#index', defaults: { format: 'json' }
```

### Configure solr to support suggestions

In your schema.xml add fields for spelling and suggestions dictionaries.  These fields must be indexed.  They should not be stored.
This example uses copyFields to include all *_s and *_sm dynamic fields in the dictionary. See the solr documentation, the default solr 
schema  and the default solrconfig for more info about configuring spellcheck dictionaries.

```xml
  <dynamicField name="*spell" type="textSpell" indexed="true" stored="false" multiValued="true" />
  <dynamicField name="*suggest" type="textSuggest" indexed="true" stored="false" multiValued="true" />

  <!-- for spell checking -->
  <copyField source="*_s" dest="spell"/>
  <copyField source="*_sm" dest="spell"/>

  <!-- for suggestions -->
  <copyField source="*_t" dest="suggest"/>
  <copyField source="*_facet" dest="suggest"/>
  <copyField source="*_s" dest="suggest"/>
  <copyField source="*_sm" dest="suggest"/>

  <fieldType name="textSuggest" class="solr.TextField" positionIncrementGap="100">
    <analyzer>
      <tokenizer class="solr.KeywordTokenizerFactory"/>
      <filter class="solr.StandardFilterFactory"/>
      <filter class="solr.LowerCaseFilterFactory"/>
      <filter class="solr.RemoveDuplicatesTokenFilterFactory"/>
    </analyzer>
  </fieldType>

  <fieldType name="textSpell" class="solr.TextField" positionIncrementGap="100" >
    <analyzer>
      <tokenizer class="solr.StandardTokenizerFactory"/>
      <filter class="solr.StopFilterFactory" ignoreCase="true" words="stopwords.txt"/>
      <filter class="solr.StandardFilterFactory"/>
      <filter class="solr.LowerCaseFilterFactory"/>
      <filter class="solr.RemoveDuplicatesTokenFilterFactory"/>
    </analyzer>
  </fieldType>
```

In your solrconfig.xml, add a searchComponent and requestHandler for suggestions

```xml
  <!-- searchComponent and requestHandler for completions -->
  <searchComponent name="suggest" class="solr.SuggestComponent">
    <lst name="suggester">
      <str name="name">mySuggester</str>
      <str name="lookupImpl">FuzzyLookupFactory</str>
      <str name="suggestAnalyzerFieldType">textSuggest</str>
      <str name="buildOnCommit">true</str>
      <str name="field">suggest</str>
    </lst>
  </searchComponent>

  <requestHandler name="/suggest" class="solr.SearchHandler" startup="lazy">
    <lst name="defaults">
      <str name="suggest">true</str>
      <str name="suggest.count">5</str>
      <str name="suggest.dictionary">mySuggester</str>
    </lst>
    <arr name="components">
      <str>suggest</str>
    </arr>
  </requestHandler>
  
  <!-- searchComponent for spellcheck -->
  <searchComponent name="spellcheck" class="solr.SpellCheckComponent">
    <!-- a spellchecker built from a field of the main index -->
    <lst name="spellchecker">
      <str name="name">default</str>
      <str name="field">spell</str>
      <str name="classname">solr.DirectSolrSpellChecker</str>
      <!-- the spellcheck distance measure used, the default is the internal levenshtein -->
      <str name="distanceMeasure">internal</str>
      <!-- minimum accuracy needed to be considered a valid spellcheck suggestion -->
      <float name="accuracy">0.5</float>
      <!-- the maximum #edits we consider when enumerating terms: can be 1 or 2 -->
      <int name="maxEdits">2</int>
      <!-- the minimum shared prefix when enumerating terms -->
      <int name="minPrefix">1</int>
      <!-- maximum number of inspections per result. -->
      <int name="maxInspections">5</int>
      <!-- minimum length of a query term to be considered for correction -->
      <int name="minQueryLength">4</int>
      <!-- maximum threshold of documents a query term can appear to be considered for correction -->
      <float name="maxQueryFrequency">0.01</float>
      <!-- uncomment this to require suggestions to occur in 1% of the documents
        <float name="thresholdTokenFrequency">.01</float>
      -->
    </lst>
  </searchComponent>
```

### Add the javascript

The engine includes very simple javascript that relies on [typeahead.js](http://twitter.github.io/typeahead.js/) and [Bloodhound](https://github.com/twitter/typeahead.js/blob/master/doc/bloodhound.md).  
It adds typeahead behavior to the blacklight search form's query field, populating it with suggestions from the '/suggest' API endpoint that this engine defines.   

If you want the default behavior, simply add this to your application.js

```javascript
//= require blacklight_suggest
```

If you want to implement your own behaviors, you can use [app/assets/javascripts/blacklight_suggest.js](app/assets/javascripts/blacklight_suggest.js) as a reference. 

### Add the CSS

Add the typeahead styles to your CSS.  This controls how suggestions appear when they're rendered on the page.
```css
@import 'modules/blacklight_suggest';
```

If you want complete control over the styling of your suggestions, you can include the base styles from typeahead.js by including this in your CSS
```css
@import 'modules/typeahead';
```

## Solr4 & Solr 5

Solr 4 - run `rake solr4:config` _before_ `rake solr4:start`  
  
These tasks are aliases to `jettywrapper` start, stop, etc.

    $ rake solr4:clean
    $ rake solr4:config
    $ rake solr4:start
    
Solr 5  
  
These tasks are aliases to `solr_wrapper` start, stop, etc.

    $ rake solr5:clean
    $ rake solr5:start
    $ rake solr5:config

## Development/Testing

After cloning the repository, cd into the directory and run the following commands.

    $ bundle 
    $ rake ci:all
    
To test only against solr4, run

    $ rake solr4:ci
    
To test only against solr5, run

    $ rake solr5:ci

If you want to run the tests outside of the ci wrapper, simply start your preferred solr version and then run 

    $ rspec

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/blacklight_suggest. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [Apache 2 License](http://www.apache.org/licenses/LICENSE-2.0).

