# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7,8} )
PYTHON_REQ_USE='threads(+)'

inherit python-any-r1 waf-utils xdg git-r3

MY_P="${PN}2-${PV}"

DESCRIPTION="Virtual guitar amplifier for Linux"
HOMEPAGE="https://guitarix.org/"
EGIT_REPO_URI="https://git.code.sf.net/p/guitarix/git"
S="${WORKDIR}/${P}/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="bluetooth debug lv2 nls nsm +standalone zeroconf"
REQUIRED_USE="|| ( lv2 standalone )"

COMMON_DEPEND="dev-cpp/eigen:3
	dev-cpp/glibmm:2
	dev-cpp/gtkmm:3.0
	dev-libs/glib:2
	>=media-libs/libsndfile-1.0.17
	>=media-libs/zita-convolver-3:=
	media-libs/zita-resampler
	>=net-misc/curl-7.26.0
	>=sci-libs/fftw-3.1.2:3.0=
	x11-libs/gtk+:3
	lv2? ( media-libs/lv2 )
	standalone? (
		dev-libs/boost:=
		media-libs/liblrdf
		media-libs/lilv
		virtual/jack
		bluetooth? ( net-wireless/bluez )
		nsm? ( media-libs/liblo )
		zeroconf? ( net-dns/avahi )
	)
"
# roboto fonts are required for correct ui rendering
RDEPEND="${COMMON_DEPEND}
	standalone? (
		media-fonts/roboto
	)
"
DEPEND="${COMMON_DEPEND}
	${PYTHON_DEPS}
	dev-lang/sassc
	virtual/pkgconfig
	nls? (
		dev-util/intltool
		sys-devel/gettext
	)
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
		$(usex nsm "" "--no-nsm")
		$(usex standalone "" "--no-standalone")
		$(usex zeroconf "" "--no-avahi")
	)
	waf-utils_src_configure "${myconf[@]}"
}
