# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Lua bindings to zlib"
HOMEPAGE="https://github.com/brimworks/lua-zlib"
SRC_URI="https://github.com/brimworks/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE=""

RDEPEND="dev-lang/lua:0
	sys-libs/zlib"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(-DINSTALL_CMOD="$(pkg-config --variable INSTALL_CMOD lua)")
	cmake-utils_src_configure
}
