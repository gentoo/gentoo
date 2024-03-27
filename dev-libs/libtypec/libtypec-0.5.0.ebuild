# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Library to interface with USB Type-c/Power Delivery devices"
HOMEPAGE="https://github.com/Rajaram-Regupathy/libtypec"
SRC_URI="https://github.com/Rajaram-Regupathy/libtypec/releases/download/${P}/${P}-Source.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

S="${WORKDIR}/${P}-Source"

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	cmake_src_configure
}

src_compile(){
	cmake_src_compile
}

src_install(){
	cmake_src_install
}
