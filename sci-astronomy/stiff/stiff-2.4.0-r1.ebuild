# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

DESCRIPTION="Converts astronomical FITS images to the TIFF format"
HOMEPAGE="http://www.astronomatic.net/software/stiff"
SRC_URI="http://www.astromatic.net/download/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc threads"

RDEPEND="
	media-libs/tiff:=
	media-libs/libjpeg-turbo:=
	virtual/zlib:="
DEPEND="${RDEPEND}"

PATCHES=(
	# https://bugs.gentoo.org/725272
	"${FILESDIR}"/${P}-autotools.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# https://bugs.gentoo.org/708382
	append-cflags -fcommon

	CONFIG_SHELL="${BROOT}"/bin/bash econf $(use_enable threads)
}

src_install() {
	default
	use doc && dodoc doc/stiff.pdf
}
