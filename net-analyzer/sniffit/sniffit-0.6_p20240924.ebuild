# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="Interactive Packet Sniffer"
HOMEPAGE="https://github.com/resurrecting-open-source-projects/sniffit"

if [[ ${PV} == *_p* ]] ; then
	SNIFFIT_COMMIT="22ab988654fa113fcc291844029a9b3889e5c84c"
	SRC_URI="https://github.com/resurrecting-open-source-projects/sniffit/archive/${SNIFFIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/${PN}-${SNIFFIT_COMMIT}
else
	SRC_URI="https://github.com/resurrecting-open-source-projects/sniffit/archive/${P}.tar.gz"
	S="${WORKDIR}"/${PN}-${P}
fi

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"

RDEPEND="
	net-libs/libpcap
	>=sys-libs/ncurses-5.2:=
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.6-tinfo.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# bug #877295
	append-flags -std=gnu89

	econf
}
