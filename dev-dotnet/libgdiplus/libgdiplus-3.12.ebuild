# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils dotnet flag-o-matic

DESCRIPTION="Library for using System.Drawing with mono"
HOMEPAGE="http://www.mono-project.com"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
SRC_URI="http://download.mono-project.com/sources/${PN}/${P}.tar.gz"

IUSE="cairo"

RDEPEND=">=dev-libs/glib-2.2.3:2
	>=media-libs/freetype-2.3.7
	>=media-libs/fontconfig-2.6
	>=media-libs/libpng-1.4:0
	x11-libs/libXrender
	x11-libs/libX11
	x11-libs/libXt
	>=x11-libs/cairo-1.8.4[X]
	media-libs/libexif
	>=media-libs/giflib-4.2.3
	virtual/jpeg:0
	media-libs/tiff:0
	!cairo? ( >=x11-libs/pango-1.20 )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-giflib-quantizebuffer.patch"
	"${FILESDIR}/${P}-underlinking.patch"
	)

RESTRICT="test"

src_prepare() {
	epatch "${PATCHES[@]}"
	sed -i -e 's:ungif:gif:g' configure.ac || die
	append-flags -fno-strict-aliasing
	eautoreconf
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		--disable-static \
		$(usex cairo "" "--with-pango")
}

src_install () {
	MAKEOPTS+=" -j1"
	default

	dotnet_multilib_comply
	local commondoc=( AUTHORS ChangeLog README TODO )
	for docfile in "${commondoc[@]}"; do
		[[ -e "${docfile}" ]] && dodoc "${docfile}"
	done
	[[ "${DOCS[@]}" ]] && dodoc "${DOCS[@]}"
	prune_libtool_files
}
