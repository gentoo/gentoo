# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils multilib-minimal

DESCRIPTION="Library for parsing video download links"
HOMEPAGE="http://quvi.sourceforge.net/"
SRC_URI="mirror://sourceforge/quvi/${PV:0:3}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0.4"
KEYWORDS="~alpha amd64 arm hppa ia64 ppc ppc64 sparc x86"
IUSE="examples static-libs"

RDEPEND=">=net-misc/curl-7.36.0[${MULTILIB_USEDEP}]
	!<media-libs/quvi-0.4.0
	>=media-libs/libquvi-scripts-0.4.21-r1:0.4[${MULTILIB_USEDEP}]
	>=dev-lang/lua-5.1.5-r3[deprecated,${MULTILIB_USEDEP}]
	!=media-libs/libquvi-0.4*:0"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog NEWS README )

multilib_src_configure() {
	local myeconfargs=(
		--without-manual
	)
	autotools-utils_src_configure
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files

	if use examples ; then
		docinto examples
		dodoc examples/*.{c,h}
	fi
}
