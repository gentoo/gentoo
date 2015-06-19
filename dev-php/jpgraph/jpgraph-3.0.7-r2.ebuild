# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/jpgraph/jpgraph-3.0.7-r2.ebuild,v 1.1 2014/10/07 19:36:16 grknight Exp $

EAPI=5

inherit eutils

KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~sparc ~x86"

DESCRIPTION="Fully OO graph drawing library for PHP"
HOMEPAGE="http://jpgraph.net/"
SRC_URI="http://hem.bredband.net/jpgraph2/${P}.tar.bz2"
LICENSE="QPL-1.0"
SLOT="0"
IUSE="truetype +examples"

DEPEND=""
RDEPEND="truetype? ( media-fonts/corefonts )
	dev-lang/php[gd,truetype?]
	"
S="${WORKDIR}"

[[ -z "${JPGRAPH_CACHEDIR}" ]] && JPGRAPH_CACHEDIR="/var/cache/jpgraph-php5/"

pkg_setup() {
	# check to which user:group the cache dir will go
	if has_version "www-servers/apache" ; then
		HTTPD_USER="apache"
		HTTPD_GROUP="apache"
		einfo "Configuring ${JPGRAPH_CACHEDIR} for Apache."
	else
		HTTPD_USER="${HTTPD_USER:-root}"
		HTTPD_GROUP="${HTTPD_GROUP:-root}"
		ewarn "No Apache webserver detected - ${JPGRAPH_CACHEDIR} will be"
		ewarn "owned by ${HTTPD_USER}:${HTTPD_GROUP} instead."
		ewarn "It this is not what you want, you can define"
		ewarn "HTTPD_USER and HTTPD_GROUP variables and re-emerge ${PN}."
		epause 3
	fi
}

src_prepare() {
	epatch "${FILESDIR}/cve-2009-4422.patch"
}

src_install() {
	# some patches to adapt the config to Gentoo
	einfo "Patching jpg-config.inc.php"

	# patch 1:
	# make jpgraph use the correct group for file permissions

	sed -i "s|^define('CACHE_FILE_GROUP','www');|define('CACHE_FILE_GROUP','${HTTPD_GROUP}');|" src/jpg-config.inc.php \
		|| die "sed failed in patch 1"

	# patch 2:
	# make jpgraph use the correct directory for caching

	sed -i "s|.*define('CACHE_DIR','/tmp/jpgraph_cache/');|define('CACHE_DIR','${JPGRAPH_CACHEDIR}');|" src/jpg-config.inc.php \
		|| die "sed failed in patch 2"

	# patch 3:
	# make jpgraph use the correct directory for the corefonts if the truetype USE flag is set

	if use truetype ; then
		sed -i "s|.*define('TTF_DIR','/usr/share/fonts/truetype/');|define('TTF_DIR','/usr/share/fonts/corefonts/');|" src/jpg-config.inc.php \
			|| die "sed failed in patch 3"
	fi

	# patch 4:
	# disable READ_CACHE in jpgraph
	sed -i "s|^define('READ_CACHE',true);|define('READ_CACHE',false);|" src/jpg-config.inc.php \
		|| die "sed failed in patch 4"

	# install php files
	einfo "Building list of files to install"
	insinto "/usr/share/php/${PN}"
	doins -r src/*

	# remove unwanted examples
	use examples || rm -rf "${D}/usr/share/php/${PN}/Examples"

	# install documentation
	einfo "Installing documentation"
	dodoc -r docportal/*
	dodoc README

	# setup the cache dir
	einfo "Setting up the cache dir"
	keepdir "${JPGRAPH_CACHEDIR}"
	fowners ${HTTPD_USER}:${HTTPD_GROUP} "${JPGRAPH_CACHEDIR}"
	fperms 750 "${JPGRAPH_CACHEDIR}"
}
