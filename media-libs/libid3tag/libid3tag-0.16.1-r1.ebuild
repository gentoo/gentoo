# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-multilib

DESCRIPTION="The MAD id3tag library, Tenacity fork"
HOMEPAGE="https://github.com/tenacityteam/libid3tag"
SRC_URI="https://github.com/tenacityteam/libid3tag/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/${PV}" # SOVERSION = ${CMAKE_PROJECT_VERSION} in CMakeLists.txt
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="sys-libs/zlib[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
