# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
PYTHON_REQ_USE='threads(+)'
inherit multiprocessing python-any-r1 waf-utils xdg

DESCRIPTION="Virtual guitar amplifier for Linux"
HOMEPAGE="https://guitarix.org/"
if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/brummer10/${PN}.git"
	EGIT_OVERRIDE_REPO_ENYOJS_BOOTPLATE="https://github.com/enyojs/bootplate.git"
	EGIT_OVERRIDE_BRANCH_ENYOJS_BOOTPLATE="master"
	S="${WORKDIR}/${P}/trunk"
else
	SRC_URI="https://github.com/brummer10/${PN}/releases/download/V${PV}/guitarix2-${PV}.tar.xz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="bluetooth debug lv2 nls nsm +standalone zeroconf"
REQUIRED_USE="|| ( lv2 standalone )"

DEPEND="
	dev-cpp/eigen:3
	dev-libs/libsigc++:2
	media-libs/libsndfile
	media-libs/zita-convolver:=
	media-libs/zita-resampler:=
	sci-libs/fftw:3.0=
	lv2? (
		media-libs/lv2
		x11-libs/cairo[X]
		x11-libs/libX11
	)
	standalone? (
		dev-libs/boost:=
		dev-cpp/atkmm:0
		dev-cpp/cairomm:0
		dev-cpp/glibmm:2
		dev-cpp/gtkmm:3.0
		dev-cpp/pangomm:1.4
		dev-libs/glib:2
		media-libs/liblrdf
		media-libs/lilv
		net-misc/curl
		virtual/jack
		x11-libs/cairo
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:3
		x11-libs/pango
		bluetooth? ( net-wireless/bluez:= )
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
		dev-util/gperf
		nls? (
			dev-util/intltool
			sys-devel/gettext
		)
	)
"

DOCS=( changelog README )

PATCHES=(
	"${FILESDIR}"/${P}-boost-1.89.patch
)

src_configure() {
	export -n {CXX,LD}FLAGS
	export STRIP="true"

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
		$(usev !bluetooth --no-bluez)
		$(usev debug --debug)
		$(usex lv2 "--lv2dir=${EPREFIX}/usr/$(get_libdir)/lv2" "--no-lv2 --no-lv2-gui")
		$(usev !nsm --no-nsm)
		$(usev !standalone --no-standalone)
		$(usev !zeroconf --no-avahi)
	)
	waf-utils_src_configure "${myconf[@]}"
}
