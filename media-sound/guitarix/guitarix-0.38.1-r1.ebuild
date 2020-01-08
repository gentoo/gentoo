# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='threads(+)'

inherit python-any-r1 waf-utils xdg

MY_P="${PN}2-${PV}"

DESCRIPTION="Virtual guitar amplifier for Linux"
HOMEPAGE="http://guitarix.org/"
SRC_URI="mirror://sourceforge/guitarix/guitarix/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE="bluetooth debug lv2 nls +standalone zeroconf"
REQUIRED_USE="|| ( lv2 standalone )"

COMMON_DEPEND="dev-cpp/eigen:3
	dev-cpp/glibmm:2
	dev-cpp/gtkmm:2.4
	dev-libs/glib:2
	>=media-libs/libsndfile-1.0.17
	>=media-libs/zita-convolver-3:=
	media-libs/zita-resampler
	>=net-misc/curl-7.26.0
	>=sci-libs/fftw-3.1.2:3.0=
	x11-libs/gtk+:2
	lv2? ( media-libs/lv2 )
	standalone? (
		dev-libs/boost:=
		media-libs/liblrdf
		media-libs/lilv
		virtual/jack
		bluetooth? ( net-wireless/bluez )
		zeroconf? ( net-dns/avahi )
	)
"
# clearlooks gtk engine and roboto fonts are required for correct ui rendering
RDEPEND="${COMMON_DEPEND}
	x11-themes/gtk-engines
	standalone? (
		media-fonts/roboto
	)
"
DEPEND="${COMMON_DEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig
	nls? ( dev-util/intltool )
"

DOCS=( changelog README )

src_configure() {
	local myconf=(
		--cxxflags-debug=""
		--cxxflags-release="-DNDEBUG"
		--ldflags="${LDFLAGS}"
		--enable-lfs
		--lib-dev
		--no-desktop-update
		--no-faust
		--no-ldconfig
		--shared-lib
		$(use_enable nls)
		$(usex bluetooth "" "--no-bluez")
		$(usex debug "--debug" "")
		$(usex lv2 "--lv2dir=${EPREFIX}/usr/$(get_libdir)/lv2" "--no-lv2 --no-lv2-gui")
		$(usex standalone "" "--no-standalone")
		$(usex zeroconf "" "--no-avahi")
	)
	waf-utils_src_configure "${myconf[@]}"
}
