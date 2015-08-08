# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit libtool

DESCRIPTION="A complete ODBC driver manager"
HOMEPAGE="http://www.unixodbc.org/"
SRC_URI="http://ftp.unixodbc.org/pub/${PN}/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="+minimal odbcmanual static-libs unicode"

RDEPEND=">=sys-devel/libtool-2.2.6b
	>=sys-libs/readline-6.1
	>=sys-libs/ncurses-5.7-r7
	virtual/libiconv"
DEPEND="${RDEPEND}
	sys-devel/flex"

DOCS="AUTHORS ChangeLog NEWS README"

src_prepare() {
	elibtoolize
}

src_configure() {
	# --enable-driver-conf is --enable-driverc as per configure.in
	econf \
		--sysconfdir="${EPREFIX}"/etc/${PN} \
		--enable-iconv \
		$(use_enable static-libs static) \
		$(use_enable !minimal drivers) \
		$(use_enable !minimal driverc) \
		$(use_with unicode iconv-char-enc UTF8) \
		$(use_with unicode iconv-ucode-enc UTF16LE)
}

src_install() {
	default

	use prefix && dodoc README*
	use odbcmanual && dohtml -a css,gif,html,sql,vsd -r doc/*

	find "${ED}" -name '*.la' -exec sed -i -e "/^dependency_libs/s:=.*:='':" {} +
}
