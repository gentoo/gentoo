# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Astrometric and photometric solutions for astronomical images"
HOMEPAGE="http://www.astromatic.net/software/scamp https://github.com/astromatic/scamp"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/astromatic/${PN}.git"
else
	SRC_URI="https://github.com/astromatic/scamp/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="plplot threads"

RDEPEND="
	sci-astronomy/cdsclient
	sci-libs/atlas[lapack,threads=]
	sci-libs/fftw:3.0
	plplot? ( sci-libs/plplot:= )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-2.10.0-spread_bits64.patch"
)

src_prepare() {
	default

	sed -e "s/lapack_atlas/atlclapack/g" -i m4/acx_atlas.m4 || die

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--with-atlas-incdir="${EPREFIX}/usr/include/atlas"
		$(use_enable plplot)
		$(use_enable threads)
	)

	econf "${myeconfargs[@]}"
}
