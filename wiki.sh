
 docker run --rm -p 1080:1080 -p 10443:10443 --name mediawiki \
   	-e MEDIAWIKI_DB_TYPE=mysql \
        -e MEDIAWIKI_DB_HOST=10.10.1.46 \
        -e MEDIAWIKI_DB_PORT=13306 \
        -e MEDIAWIKI_DB_USER=wikiuser \
        -e MEDIAWIKI_DB_PASSWORD=wikipass \
        -e MEDIAWIKI_DB_NAME=wikidb \
	-e MEDIAWIKI_SITE_SERVER=//my-wiki \
        -e MEDIAWIKI_SITE_NAME="My Wiki" \
        wiki
