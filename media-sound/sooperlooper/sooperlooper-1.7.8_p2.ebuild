# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
WX_GTK_VER=3.2-gtk3

inherit autotools wxwidgets toolchain-funcs desktop xdg

DESCRIPTION="Live looping sampler with immediate loop recording"
HOMEPAGE="https://sonosaurus.com/sooperlooper/index.html"
SRC_URI="https://sonosaurus.com/${PN}/${P/_p*}.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV/_p*}~dfsg0-${PV/*_p}.debian.tar.xz
	mirror://gentoo/${PN}-1.6.5-m4.tar.bz2
	https://dev.gentoo.org/~pacho/${PN}/${PN}.png
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="wxwidgets"

RDEPEND="
	>=media-libs/liblo-0.18
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
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${P/_p*}"

DOCS=( OSC README )

src_prepare() {
	default

	# Debian patches
	for p in $(<"${WORKDIR}"/debian/patches/series) ; do
		eapply -p1 "${WORKDIR}/debian/patches/${p}"
	done

	cp -rf "${WORKDIR}"/aclocal "${S}" || die "copying aclocal failed"
	AT_M4DIR="${S}"/aclocal eautoreconf
}

src_configure() {
	use wxwidgets && setup-wxwidgets
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

	if use wxwidgets; then
		make_desktop_entry /usr/bin/slgui SooperLooper
		doicon "${DISTDIR}"/${PN}.png
	fi
}
