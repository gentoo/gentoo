# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils dotnet

DESCRIPTION="Library for using System.Drawing with Mono"
HOMEPAGE="https://www.mono-project.com"
SRC_URI="https://download.mono-project.com/sources/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="cairo"
#skip tests due https://bugs.gentoo.org/687784
RESTRICT="test"

RDEPEND="dev-libs/glib
	media-libs/freetype
	media-libs/fontconfig
	>=media-libs/giflib-5.1.2
	media-libs/libexif
	media-libs/libpng:0=
	media-libs/tiff
	x11-libs/cairo[X]
	x11-libs/libX11
	x11-libs/libXrender
	x11-libs/libXt
	virtual/jpeg:0
	!cairo? ( x11-libs/pango )"
DEPEND="${RDEPEND}"

src_configure() {
	econf \
		--disable-dependency-tracking \
		--disable-static \
		$(usex cairo "" "--with-pango")
}

src_install () {
	default

	dotnet_multilib_comply
	local commondoc=( AUTHORS ChangeLog README TODO )
	for docfile in "${commondoc[@]}"; do
		[[ -e "${docfile}" ]] && dodoc "${docfile}"
	done
	[[ "${DOCS[@]}" ]] && dodoc "${DOCS[@]}"
	prune_libtool_files
}
