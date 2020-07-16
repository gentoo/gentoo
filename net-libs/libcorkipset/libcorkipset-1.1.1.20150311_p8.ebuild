# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils

DATE=20150311
MY_PV="${PV/.${DATE}_p/+${DATE}-}"
MY_PX="${PV/.${DATE}_p/-${DATE}-}"

DESCRIPTION="A small C helper library for storing sets of IPv4 and IPv6 addresses"
HOMEPAGE="https://github.com/rogers0/libcorkipset"
SRC_URI="https://github.com/rogers0/${PN}/archive/debian/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

DEPEND="net-libs/libcork"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-debian-${MY_PX}"

src_prepare() {
	rm -f "${S}"/debian/patches/0001*.patch || die
	eapply "${S}"/debian/patches/*.patch

	sed -e 's%#include <ipset%#include <libcorkipset%' \
		-e 's%#include "ipset%#include "libcorkipset%' \
		-i include/ipset/*.h \
			*/*/*/*.c \
			*/*/*/*.c.in \
			*/*/*.c */*.c || die

	mv include/{,libcork}ipset || die

	cmake-utils_src_prepare
}
