# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Linear/Logitudinal Time Code (LTC) Library"
HOMEPAGE="https://github.com/x42/libltc"
if [[ ${PV} == *9999 ]]; then
	inherit git-r3 autotools
	EGIT_REPO_URI="https://github.com/x42/libltc"
else
	inherit libtool
	SRC_URI="https://github.com/x42/libltc/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="~amd64"
fi
LICENSE="LGPL-3"
SLOT="0"
RESTRICT="mirror"

src_prepare() {
	default

	if [[ ${PV} = *9999 ]]; then
		eautoreconf
	else
		elibtoolize
	fi
}

src_install() {
	default
	find "${ED}" \( -name "*.a" -o -name "*.la" \) -delete || die
}
