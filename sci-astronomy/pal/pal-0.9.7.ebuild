# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils ltprune

DESCRIPTION="Positional Astronomy Library"
HOMEPAGE="https://github.com/Starlink/pal"
SRC_URI="https://github.com/Starlink/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc static-libs"
RDEPEND="sci-astronomy/erfa:="
DEPEND="${RDEPEND}"

src_configure() {
	econf --without-starlink \
		  --without-stardocs \
		  --with-erfa \
		  $(use_enable static-libs static)
}

src_install() {
	default
	# remove cruft from non-fhs complient
	rm -r "${ED}"usr/share/pal || die
	rm -r "${ED}"usr/{docs,manifests,news} || die
	use static-libs || prune_libtool_files --all
}
