# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lua/lua-zlib/lua-zlib-0.3.ebuild,v 1.5 2015/06/06 19:41:11 jlec Exp $

EAPI=5

inherit cmake-utils

DESCRIPTION="Lua bindings to zlib"
HOMEPAGE="http://github.com/brimworks/lua-zlib"
SRC_URI="https://github.com/brimworks/${PN}/tarball/v${PV} -> ${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE=""

RDEPEND="
	dev-lang/lua:0
	sys-libs/zlib"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_unpack() {
	unpack ${A}
	mv *-${PN}-* "${S}"
}

src_configure() {
	MYCMAKEARGS="-DINSTALL_CMOD='$(pkg-config --variable INSTALL_CMOD lua)'"
	cmake-utils_src_configure
}
