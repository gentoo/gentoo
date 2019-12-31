# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Extensible binary format library (kinda like XML)"
HOMEPAGE="https://www.matroska.org/ https://github.com/Matroska-Org/libebml/"
SRC_URI="https://dl.matroska.org/downloads/${PN}/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0/4" # subslot = soname major version
KEYWORDS="alpha amd64 arm arm64 ~hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

src_configure() {
	local mycmakeargs=( -DBUILD_SHARED_LIBS=YES )
	cmake_src_configure
}
