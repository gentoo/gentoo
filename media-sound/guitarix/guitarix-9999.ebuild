# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..12} )
PYTHON_REQ_USE='threads(+)'

EGIT_OVERRIDE_REPO_ENYOJS_BOOTPLATE="https://github.com/enyojs/bootplate.git"
EGIT_OVERRIDE_BRANCH_ENYOJS_BOOTPLATE="master"

inherit multiprocessing python-any-r1 waf-utils xdg git-r3

DESCRIPTION="Virtual guitar amplifier for Linux"
HOMEPAGE="https://guitarix.org/"
EGIT_REPO_URI="https://github.com/brummer10/${PN}.git"
S="${WORKDIR}/${P}/trunk"

LICENSE="GPL-2"
SLOT="0"
IUSE="bluetooth debug lv2 nls nsm +standalone zeroconf"
REQUIRED_USE="|| ( lv2 standalone )"

DEPEND="
	dev-cpp/eigen:3
	dev-cpp/glibmm:2
	dev-cpp/gtkmm:3.0
	dev-libs/glib:2
	media-libs/libsndfile
	media-libs/zita-convolver:=
	media-libs/zita-resampler
	net-misc/curl
	sci-libs/fftw:3.0=
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
RDEPEND="
	${DEPEND}
	standalone? (
		media-fonts/roboto
	)
"
BDEPEND="
	${PYTHON_DEPS}
	virtual/pkgconfig
	standalone? (
		dev-lang/sassc
		nls? (
			dev-util/intltool
			sys-devel/gettext
		)
	)
"

DOCS=( changelog README )

src_configure() {
	export -n {CXX,LD}FLAGS

	local myconf=(
		--cxxflags="${CXXFLAGS}"
		--cxxflags-debug=""
		--cxxflags-release="-DNDEBUG"
		--ldflags="${LDFLAGS}"
		--enable-lfs
		--lib-dev
		--no-desktop-update
		--no-faust
		--no-ldconfig
		--shared-lib
		--jobs=$(makeopts_jobs)
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
