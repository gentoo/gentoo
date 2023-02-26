# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit autotools

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="git://sigrok.org/${PN}"
	inherit git-r3
else
	SRC_URI="https://sigrok.org/download/source/${PN}/${P}.tar.gz"
	KEYWORDS="amd64 ~arm ~arm64 x86"
fi

DESCRIPTION="Cross platform serial port access library"
HOMEPAGE="https://sigrok.org/wiki/Libserialport"

LICENSE="LGPL-3"
SLOT="0"
IUSE="static-libs"

BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-kernel-termiox.patch
)

src_prepare() {
	default

	#[[ ${PV} == "9999" ]] && eautoreconf
	# Needed for the termiox patch, should be able to drop on next release
	# (change back this + inherit to just for 9999)
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default

	find "${ED}" -name '*.la' -type f -delete || die
}
