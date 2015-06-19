# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-servers/gorg/gorg-0.7.0.ebuild,v 1.6 2014/05/07 19:04:51 mrueg Exp $

EAPI=5
USE_RUBY="ruby19 ruby20"

inherit ruby-ng eutils user

DESCRIPTION="Back-end XSLT processor for an XML-based web site"
HOMEPAGE="http://www.gentoo.org/proj/en/gdp/doc/gorg.xml"
SRC_URI="https://github.com/gentoo/gorg/archive/v${PV}.tar.gz -> ${P}.tar.gz"
IUSE="fastcgi"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc x86"

CDEPEND="
	>=dev-libs/libxml2-2.6.16
	>=dev-libs/libxslt-1.1.12"
DEPEND="${DEPEND} ${CDEPEND}"
RDEPEND="${RDEPEND} ${CDEPEND}
		fastcgi? ( virtual/httpd-fastcgi )"

ruby_add_rdepend "
	fastcgi? ( >=dev-ruby/fcgi-0.8.5-r1 )"

pkg_setup() {
	enewgroup gorg
	enewuser  gorg -1 -1 -1 gorg
}

each_ruby_configure() {
	${RUBY} setup.rb config --prefix=/usr || die
}

each_ruby_compile() {
	${RUBY} setup.rb setup || die
}

each_ruby_install() {
	${RUBY} setup.rb config --prefix="${D}"/usr || die
	${RUBY} setup.rb install                    || die

	# install doesn't seem to chmod these correctly, forcing it here
	SITE_LIB_DIR=$(ruby_rbconfig_value 'sitelibdir')
	chmod +x "${D}"/${SITE_LIB_DIR}/gorg/cgi-bin/*.cgi
	chmod +x "${D}"/${SITE_LIB_DIR}/gorg/fcgi-bin/*.fcgi
}

all_ruby_install() {
	keepdir /etc/gorg; insinto /etc/gorg ; doins etc/gorg/*
	diropts -m0770 -o gorg -g gorg; keepdir /var/cache/gorg

	dodoc Changelog README
}
