# blog-dev.likewise.org

```
python3 -m venv env
source env/bin/activate
pip install -r requirements.txt

git clone https://github.com/duilio/pelican-octopress-theme.git \
  ~/github/duilio/pelican-octopress-theme

pelican-quickstart

> Where do you want to create your new web site? [.]
> What will be the title of this web site? Bill Agee's blog
> Who will be the author of this web site? Bill Agee
> What will be the default language of this web site? [en]
> Do you want to specify a URL prefix? e.g., https://example.com   (Y/n)
> What is your URL prefix? (see above example; no trailing slash) https://blog-dev.likewise.org
> Do you want to enable article pagination? (Y/n)
> How many articles per page do you want? [10]
> What is your time zone? [Europe/Rome] America/Los_Angeles
> Do you want to generate a tasks.py/Makefile to automate generation and publishing? (Y/n)
> Do you want to upload your website using FTP? (y/N)
> Do you want to upload your website using SSH? (y/N)
> Do you want to upload your website using Dropbox? (y/N)
> Do you want to upload your website using S3? (y/N) y
> What is the name of your S3 bucket? [my_s3_bucket] blog-dev.likewise.org
> Do you want to upload your website using Rackspace Cloud Files? (y/N)
> Do you want to upload your website using GitHub Pages? (y/N)


Add to pelicanconf.py:

THEME="/Users/billagee/github/duilio/pelican-octopress-theme"
```

Launch the local dev server with:
```
make devserver
```

Deploy to S3 and CloudFront with:
```
make s3_upload
```
