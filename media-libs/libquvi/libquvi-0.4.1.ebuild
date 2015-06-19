# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libquvi/libquvi-0.4.1.ebuild,v 1.16 2014/03/04 20:42:46 vincent Exp $

EAPI=5

inherit autotools-utils

DESCRIPTION="Library for parsing video download links"
HOMEPAGE="http://quvi.sourceforge.net/"
SRC_URI="mirror://sourceforge/quvi/${PV:0:3}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm hppa ia64 ~mips ppc ppc64 sparc x86"
IUSE="examples static-libs"

RDEPEND=">=net-misc/curl-7.18.2
	!<media-libs/quvi-0.4.0
	>=media-libs/libquvi-scripts-0.4.0
	>=dev-lang/lua-5.1[deprecated]"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog NEWS README )

src_configure() {
	local myeconfargs=(
		--with-manual
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	if use examples ; then
		docinto examples
		dodoc examples/*.{c,h}
	fi
}
