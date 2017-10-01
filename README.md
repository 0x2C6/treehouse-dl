# treehouse-dl
Download Treehouse videos without pro membership

Now you can download Treehouse videos easly. You need account with any membership (even trailer)

## Installation

```
gem install treehouse-dl
```

### Manual installation
```sh
 user@User ~ $ git clone https://github.com/0x2C6/treehouse-dl.git
 user@User ~ $ cd treehouse-dl
 user@User ~ $ bundle
 user@User ~ $ chmod +x setup.rb
 user@User ~ $ ./setup.rb
```


##Usage

```
treehouse-dl -e EMAIL -p PASSWORD -u URL
```



You have to fill all sections!
Else it won't work
Please write valid course url

###Example

```
treehouse-dl -e example@email.com -p 123456aA -u https://teamtreehouse.com/library/unit-testing-in-java
```

This is beta versions and include some errors . Please create new issue if you get any error.
