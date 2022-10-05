# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} != 1.4.2 ]] ; then
	die "Do not bump to 1.4.3! It breaks ABI: https://github.com/Matroska-Org/libebml/issues/104"
fi

inherit cmake

DESCRIPTION="Extensible binary format library (kinda like XML)"
HOMEPAGE="https://www.matroska.org/ https://github.com/Matroska-Org/libebml/"
SRC_URI="https://dl.matroska.org/downloads/${PN}/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0/5" # subslot = soname major version
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

PATCHES=(
	"${FILESDIR}/${P}-header-fixes-for-gcc11.patch"
)
