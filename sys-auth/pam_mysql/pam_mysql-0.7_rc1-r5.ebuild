# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/pam_mysql/pam_mysql-0.7_rc1-r5.ebuild,v 1.6 2015/06/28 17:57:34 zlogene Exp $

EAPI=5
inherit autotools-utils pam

DESCRIPTION="pam_mysql is a module for pam to authenticate users with mysql"
HOMEPAGE="http://pam-mysql.sourceforge.net/"

SRC_URI="mirror://sourceforge/pam-mysql/${P/_rc/RC}.tar.gz"
DEPEND="
	openssl? ( dev-libs/openssl:0= )
	>=sys-libs/pam-0.72:0=
	virtual/mysql:0=
	"
RDEPEND="${DEPEND}"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc sparc x86"
IUSE="openssl"
S="${WORKDIR}/${P/_rc/RC}"

PATCHES=(
	"${FILESDIR}/${P}-link-to-pam.diff"
	"${FILESDIR}/${P}-memleak.diff"
	)
DOCS=( CREDITS ChangeLog NEWS README )
AUTOTOOLS_AUTORECONF="yes"
AUTOTOOLS_PRUNE_LIBTOOL_FILES="modules"

src_prepare() {
	# Update autotools deprecated file name and macro for bug 468750
	mv configure.in configure.ac || die "configure rename failed"
	sed -i s/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/ configure.ac || die "sed failed"
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=( $(use_with openssl) )
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install libdir="$(getpam_mod_dir)"
}
