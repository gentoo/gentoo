# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake

DATE=20150311
MY_PV="${PV/.${DATE}_p/+${DATE}-}"
MY_PX="${PV/.${DATE}_p/-${DATE}-}"

DESCRIPTION="A small C helper library for storing sets of IPv4 and IPv6 addresses"
HOMEPAGE="https://github.com/rogers0/libcorkipset"
SRC_URI="https://github.com/rogers0/${PN}/archive/debian/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
IUSE=""

DEPEND="net-libs/libcork"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-debian-${MY_PX}"

PATCHES=(
	"${S}"/debian/patches/
	"${FILESDIR}"/cmake-min-ver-3.10.patch
)

src_prepare() {
	cmake_src_prepare

	sed -i -e "/^version=/s/=.*$/=${MY_PX}/" version.sh || die
	sed -e 's%#include <ipset%#include <libcorkipset%' \
		-e 's%#include "ipset%#include "libcorkipset%' \
		-i include/ipset/*.h \
			*/*/*/*.c \
			*/*/*/*.c.in \
			*/*/*.c */*.c || die
	sed -e "s/-Werror/-Wextra/" \
		-e "/^add_subdirectory(docs)/d" \
		-i CMakeLists.txt || die

	mv include/{,libcork}ipset || die
}
