# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info

DESCRIPTION="Lib for the use of linux kernel's sysfs gpio interface from C programs"
HOMEPAGE="https://github.com/mhei/libugpio"
SRC_URI="https://github.com/mhei/${PN}/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="GPL-3+ LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"

CONFIG_CHECK="~CONFIG_GPIO_SYSFS"

src_configure() {
	local myeconfargs=(
		--disable-static
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	find "${D}" -name '*.la' -delete || die
}
