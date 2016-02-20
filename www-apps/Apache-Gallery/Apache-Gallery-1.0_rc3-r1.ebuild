# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit depend.apache perl-module webapp

MY_P=${P/_rc/RC}

DESCRIPTION="Apache gallery for mod_perl"
SRC_URI="http://apachegallery.dk/download/${MY_P}.tar.gz"
HOMEPAGE="http://apachegallery.dk/"

LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="amd64 ppc x86"
IUSE=""

WEBAPP_MANUAL_SLOT="yes"
SLOT="0"

S=${WORKDIR}/${MY_P}

DEPEND="${DEPEND}
	=dev-lang/perl-5*
	=www-apache/libapreq2-2*[perl]
	>=media-libs/imlib2-1.0.6-r1
	dev-perl/URI
	>=dev-perl/Image-Info-1.40.0
	>=dev-perl/Image-Size-2.990.0
	dev-perl/text-template
	>=dev-perl/CGI-3.08
	dev-perl/Image-Imlib2
"

need_apache2

src_install() {
	perl-module_src_install
	webapp_src_preinst

	dodoc Changes INSTALL README TODO UPGRADE || die

	insinto "${MY_ICONSDIR}"/gallery
	doins htdocs/*.png

	dodir "${MY_HOSTROOTDIR}"/${PN}/templates/default
	dodir "${MY_HOSTROOTDIR}"/${PN}/templates/new

	insinto "${MY_HOSTROOTDIR}"/${PN}/templates/default
	doins templates/default/*

	insinto "${MY_HOSTROOTDIR}"/${PN}/templates/new
	doins templates/new/*

	insinto "${APACHE_VHOSTS_CONFDIR}"
	doins "${FILESDIR}"/76_apache2-gallery.conf

	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	webapp_src_install
}
