# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Small c++ Interface library for the external HX711 chip thru GPIO"

HOMEPAGE="https://github.com/endail/hx711"

SRC_URI="https://github.com/endail/hx711/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"

SLOT="0"

# for SBC's (such as Raspberry Pi)
KEYWORDS="~arm ~arm64"

COMMON_DEPEND=">=dev-libs/lg-0.2"

DEPEND="${COMMON_DEPEND}"

BDEPEND="${COMMON_DEPEND}"

src_compile() {
# no stable compile parallelism
	emake -j1
}
