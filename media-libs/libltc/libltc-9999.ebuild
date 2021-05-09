# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Linear/Logitudinal Time Code (LTC) Library"
HOMEPAGE="https://github.com/x42/libltc.git"
if [[ ${PV} == *9999 ]]; then
	inherit git-r3 autotools
	EGIT_REPO_URI="https://github.com/x42/libltc.git"
else
	SRC_URI="https://github.com/x42/libltc/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="~amd64"
fi
LICENSE="LGPL-3"
SLOT="0"
RESTRICT="mirror"

src_prepare() {
	default

	[[ ${PV} == *9999 ]] && (eautoreconf || die)
}
