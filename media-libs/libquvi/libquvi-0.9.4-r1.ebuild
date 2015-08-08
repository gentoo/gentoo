# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
AUTOTOOLS_AUTORECONF=1

inherit autotools-utils multilib-minimal

DESCRIPTION="Library for parsing video download links"
HOMEPAGE="http://quvi.sourceforge.net/"
SRC_URI="mirror://sourceforge/quvi/${PV:0:3}/${P}.tar.xz"

LICENSE="AGPL-3"
SLOT="0/8" # subslot = libquvi soname version
KEYWORDS="amd64 ~arm hppa ppc ppc64 sparc x86"
IUSE="examples nls static-libs"

RDEPEND="!<media-libs/quvi-0.4.0
	>=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}]
	>=dev-libs/libgcrypt-1.5.3:0=[${MULTILIB_USEDEP}]
	>=media-libs/libquvi-scripts-0.9.20130903[${MULTILIB_USEDEP}]
	>=net-libs/libproxy-0.4.11-r1[${MULTILIB_USEDEP}]
	>=net-misc/curl-7.36.0[${MULTILIB_USEDEP}]
	>=dev-lang/lua-5.1.5-r3[deprecated,${MULTILIB_USEDEP}]
	nls? ( >=virtual/libintl-0-r1[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
	nls? ( sys-devel/gettext )"

PATCHES=( "${FILESDIR}"/${PN}-0.9.1-headers-reinstall.patch )

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable nls)
		--with-manual
	)
	autotools-utils_src_configure
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files

	use examples && dodoc -r examples
}
