# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
WX_GTK_VER=3.0

inherit autotools flag-o-matic wxwidgets toolchain-funcs

DESCRIPTION="Live looping sampler with immediate loop recording"
HOMEPAGE="http://essej.net/sooperlooper/index.html"
SRC_URI="http://essej.net/sooperlooper/${P/_p/-}.tar.gz
	mirror://gentoo/${PN}-1.6.5-m4.tar.bz2
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="wxwidgets"

RDEPEND="
	media-sound/jack-audio-connection-kit
	>=media-libs/liblo-0.10
	>=dev-libs/libsigc++-2.8:2
	>=media-libs/libsndfile-1.0.2
	>=media-libs/libsamplerate-0.0.13
	dev-libs/libxml2:2
	>=media-libs/rubberband-0.0.13
	sci-libs/fftw:3.0=
	wxwidgets? ( x11-libs/wxGTK:${WX_GTK_VER} )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

S="${WORKDIR}/${P/_p*}"

DOCS=( OSC README )

PATCHES=(
	"${FILESDIR}"/${P}-wx3.0.patch
	"${FILESDIR}"/${P}-libsigc28.patch
	"${FILESDIR}"/${P}-clash.patch
	"${FILESDIR}"/${P}-tinfo.patch
)

src_prepare() {
	default
	cp -rf "${WORKDIR}"/aclocal "${S}" || die "copying aclocal failed"
	AT_M4DIR="${S}"/aclocal eautoreconf
}

src_configure() {
	use wxwidgets && need-wxwidgets unicode
	append-cppflags -std=c++11 # Its ugly build system honors CPPFLAGS instead of CXXFLAGS for this
	econf \
		$(use_with wxwidgets gui) \
		--disable-optimize \
		--with-wxconfig-path="${WX_CONFIG}"
}

src_compile() {
	emake AR="$(tc-getAR)"
}
