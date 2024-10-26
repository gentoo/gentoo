# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/sigrokproject/${PN}.git"
	inherit autotools git-r3
else
	SRC_URI="https://sigrok.org/download/source/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

DESCRIPTION="Cross platform serial port access library"
HOMEPAGE="https://sigrok.org/wiki/Libserialport"

LICENSE="LGPL-3"
SLOT="0"
IUSE="static-libs"

BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	[[ ${PV} == "9999" ]] && eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default

	find "${ED}" -name '*.la' -type f -delete || die
}
