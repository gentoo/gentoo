# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
WX_GTK_VER=3.0-gtk3

inherit autotools flag-o-matic wxwidgets toolchain-funcs desktop xdg

DESCRIPTION="Live looping sampler with immediate loop recording"
HOMEPAGE="http://essej.net/sooperlooper/index.html"
SRC_URI="http://essej.net/sooperlooper/${P/_p/-}.tar.gz
	mirror://gentoo/${PN}-1.6.5-m4.tar.bz2
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="wxwidgets"

BDEPEND="
	virtual/pkgconfig
"
RDEPEND="
	media-libs/liblo
	dev-libs/libsigc++:2
	media-libs/libsndfile
	media-libs/libsamplerate
	dev-libs/libxml2:2
	media-libs/rubberband
	sci-libs/fftw:3.0=
	virtual/jack
	wxwidgets? ( x11-libs/wxGTK:${WX_GTK_VER} )
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P/_p*}"

DOCS=( OSC README )

src_prepare() {
	default
	cp -rf "${WORKDIR}"/aclocal "${S}" || die "copying aclocal failed"
	AT_M4DIR="${S}"/aclocal eautoreconf
}

src_configure() {
	use wxwidgets && setup-wxwidgets
	append-cppflags -std=c++11 # Its ugly build system honors CPPFLAGS instead of CXXFLAGS for this
	econf \
		$(use_with wxwidgets gui) \
		--disable-optimize \
		--with-wxconfig-path="${WX_CONFIG}"
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	default

	use wxwidgets && make_desktop_entry /usr/bin/slgui SooperLooper
}
