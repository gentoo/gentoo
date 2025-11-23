# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Positional Astronomy Library"
HOMEPAGE="https://github.com/Starlink/pal"
SRC_URI="https://github.com/Starlink/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"
RDEPEND="sci-astronomy/erfa:="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.9.8-fix-strlcpy-musl.patch
)

src_configure() {
	econf --without-starlink \
		  --without-stardocs \
		  --with-erfa \
		  $(use_enable static-libs static)
}

src_install() {
	default

	# remove cruft from non-fhs compliant
	dodoc -r "${ED}"/usr/{docs,manifests,news}
	rm -r "${ED}"/usr/{docs,manifests,news} || die

	if ! use static-libs; then
		find "${ED}" -name '*.la' -delete || die
	fi
}
