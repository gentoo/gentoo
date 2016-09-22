# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit libtool autotools-multilib eutils

DESCRIPTION="A complete ODBC driver manager"
HOMEPAGE="http://www.unixodbc.org/"
SRC_URI="http://ftp.unixodbc.org/pub/${PN}/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="+minimal odbcmanual static-libs unicode"

RDEPEND="|| (
		dev-libs/libltdl:0[${MULTILIB_USEDEP}]
		>=sys-devel/libtool-2.4.2-r1[${MULTILIB_USEDEP}]
	)
	>=sys-libs/readline-6.2_p5-r1:0=[${MULTILIB_USEDEP}]
	>=sys-libs/ncurses-5.9-r3:0=[${MULTILIB_USEDEP}]
	>=virtual/libiconv-0-r1[${MULTILIB_USEDEP}]
	abi_x86_32? ( !app-emulation/emul-linux-x86-db[-abi_x86_32(-)] )"
DEPEND="${RDEPEND}
	sys-devel/flex"

DOCS="AUTHORS ChangeLog NEWS README"
MULTILIB_CHOST_TOOLS=( /usr/bin/odbc_config )
MULTILIB_WRAPPED_HEADERS=( /usr/include/unixodbc_conf.h )

src_configure() {
	# --enable-driver-conf is --enable-driverc as per configure.in
	myeconfargs=(
		--sysconfdir="${EPREFIX}"/etc/${PN}
		--enable-iconv
		$(use_enable static-libs static)
		$(use_enable !minimal drivers)
		$(use_enable !minimal driverc)
		$(use_with unicode iconv-char-enc UTF8)
		$(use_with unicode iconv-ucode-enc UTF16LE)
	)
	autotools-multilib_src_configure
}

multilib_src_install_all() {
	einstalldocs

	use prefix && dodoc README*
	use odbcmanual && dohtml -a css,gif,html,sql,vsd -r doc/*

	find "${ED}" -name '*.la' -exec sed -i -e "/^dependency_libs/s:=.*:='':" {} +
}
