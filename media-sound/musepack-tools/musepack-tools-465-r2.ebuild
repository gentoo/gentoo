# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

# svn export http://svn.musepack.net/libmpc/trunk musepack-tools-${PV}
# tar -cjf musepack-tools-${PV}.tar.bz2 musepack-tools-${PV}

DESCRIPTION="Musepack SV8 libraries and utilities"
HOMEPAGE="https://www.musepack.net"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="BSD LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"

DEPEND="
	>=media-libs/libcuefile-${PV}
	>=media-libs/libreplaygain-${PV}
"
RDEPEND="
	${DEPEND}
	!media-libs/libmpcdec
	!media-libs/libmpcdecsv7
"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-fno-common.patch
)
