# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/openpam/openpam-20140912.ebuild,v 1.1 2015/02/22 10:03:44 mgorny Exp $

EAPI="5"

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_PRUNE_LIBTOOL_FILES=all

inherit multilib autotools-multilib

DESCRIPTION="Open source PAM library"
HOMEPAGE="http://www.openpam.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE="debug vim-syntax"

RDEPEND="!sys-libs/pam"
DEPEND="sys-devel/make
	dev-lang/perl"
PDEPEND="sys-auth/pambase
	vim-syntax? ( app-vim/pam-syntax )"

PATCHES=(
	"${FILESDIR}/${PN}-20130907-gentoo.patch"
	"${FILESDIR}/${PN}-20130907-nbsd.patch"
	"${FILESDIR}/${PN}-20130907-module-dir.patch"
	)

DOCS=( CREDITS HISTORY RELNOTES README )

src_prepare() {
	sed -i -e 's:-Werror::' "${S}/configure.ac"

	autotools-multilib_src_prepare
}

my_configure() {
	local myeconfargs=(
		--with-modules-dir=/$(get_libdir)/security
		)
	autotools-utils_src_configure
}

src_configure() {
	multilib_parallel_foreach_abi my_configure
}
