# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

MY_PN="id3tag"
MY_P="${MY_PN}-${PV}-source"
DESCRIPTION="The MAD id3tag library, Tenacity fork"
HOMEPAGE="https://codeberg.org/tenacityteam/libid3tag"
SRC_URI="https://codeberg.org/tenacityteam/libid3tag/releases/download/${PV}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0/${PV}" # SOVERSION = ${PROJECT_VERSION} in CMakeLists.txt
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="virtual/zlib:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND="dev-util/gperf"
