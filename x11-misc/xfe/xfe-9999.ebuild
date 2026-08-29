# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PLOCALES="
	bs ca cs da de el es_AR es_CO es fr hu it ja nl no pl pt_BR pt_PT ru sv tr
	zh_CN zh_TW
"
inherit autotools plocale xdg

DESCRIPTION="MS-Explorer-like minimalist file manager for X"
HOMEPAGE="http://roland65.free.fr/xfe/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/roland65/xfe.git"
else
	SRC_URI="https://downloads.sourceforge.net/${PN}/${PN}/${PV}/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
fi

LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	x11-libs/fox:1.6[png,truetype]
	media-libs/fontconfig
	x11-libs/libXrandr
	x11-libs/libX11
	x11-libs/libXft
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/intltool
	virtual/pkgconfig
	nls? (
		sys-devel/gettext
	)
"

DOCS=( AUTHORS BUGS ChangeLog README TODO COPYING NEWS ABOUT-NLS )

IUSE="debug nls"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable nls)
}
