
 docker run --rm -P --name mediawiki \
   	-e MEDIAWIKI_DB_TYPE=mysql \
        -e MEDIAWIKI_DB_HOST=10.10.1.36 \
        -e MEDIAWIKI_DB_PORT=35357 \
        -e MEDIAWIKI_DB_USER=wikiuser \
        -e MEDIAWIKI_DB_PASSWORD=wikipass \
        -e MEDIAWIKI_DB_NAME=wikidb \
	-e MEDIAWIKI_SITE_SERVER=//my-wiki \
        -e MEDIAWIKI_SITE_NAME="My Wiki" \
        wiki
