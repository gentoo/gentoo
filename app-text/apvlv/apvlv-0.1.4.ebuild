# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils cmake-utils

MY_P="${P}-Source"
DESCRIPTION="Alf's PDF Viewer Like Vim"
HOMEPAGE="https://naihe2010.github.com/apvlv/"
SRC_URI="mirror://github/naihe2010/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug djvu"

RDEPEND="
	>=app-text/poppler-0.18:=[cairo,xpdf-headers(+)]
	>=x11-libs/gtk+-2.10.4:2
	djvu? ( app-text/djvu:= )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

S=${WORKDIR}/${MY_P}

src_prepare() {
	# Webkit automagic, preserve cflags
	epatch "${FILESDIR}/${PN}-0.1.4-cmake.patch"

	# Remove prefixes so it works with the cmake-utils eclass
	sed -i -e "s:APVLV_::" CMakeLists.txt src/CMakeLists.txt || die

	# Don't install tex file
	sed -i -e "s:Startup.tex::" CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DSYSCONFDIR=/etc/${PN}
		-DDOCDIR=/usr/share/${PN}
		-DMANDIR=/usr/share/man
		-DWITH_HTML=OFF
		-DWITH_UMD=OFF
		-DWITH_TXT=ON
		$(cmake-utils_use_with djvu)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dodoc AUTHORS NEWS README THANKS TODO
	newicon icons/pdf.png ${PN}.png
	make_desktop_entry ${PN} "Alf's PDF Viewer Like Vim" ${PN} "Office;Viewer"
}
