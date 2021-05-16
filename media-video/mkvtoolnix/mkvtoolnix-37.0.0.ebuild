# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs multiprocessing qmake-utils xdg

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://gitlab.com/mbunkus/mkvtoolnix.git"
	EGIT_SUBMODULES=()
	inherit autotools git-r3
else
	SRC_URI="https://mkvtoolnix.download/sources/${P}.tar.xz"
	KEYWORDS="amd64 ppc ppc64 x86"
fi

DESCRIPTION="Tools to create, alter, and inspect Matroska files"
HOMEPAGE="https://mkvtoolnix.download/ https://gitlab.com/mbunkus/mkvtoolnix"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug nls pch test qt5"
RESTRICT="!test? ( test )"

# check NEWS.md for build system changes entries for boost/libebml/libmatroska
# version requirement updates and other packaging info
RDEPEND="
	dev-libs/boost:=
	>=dev-libs/libebml-1.3.7:=
	>=dev-libs/libfmt-5.3.0:=
	dev-libs/pugixml:=
	media-libs/flac:=
	>=media-libs/libmatroska-1.5.0:=
	media-libs/libogg:=
	media-libs/libvorbis:=
	sys-apps/file
	sys-libs/zlib
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtwidgets:5
		dev-qt/qtconcurrent:5
		dev-qt/qtmultimedia:5
		app-text/cmark:0=
	)
"
DEPEND="${RDEPEND}
	dev-cpp/nlohmann_json
	dev-libs/utfcpp
	test? ( dev-cpp/gtest )
"
BDEPEND="
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	dev-ruby/rake
	virtual/pkgconfig
	nls? (
		sys-devel/gettext
		app-text/po4a
	)
"

src_prepare() {
	xdg_src_prepare
	if [[ ${PV} == *9999 ]]; then
		./autogen.sh || die
	fi

	# remove bundled libs
	rm -r lib/{fmt,libebml,libmatroska,nlohmann-json,pugixml,utf8-cpp} || die
}

src_configure() {
	# bug 692322, use system dev-libs/utfcpp
	append-cppflags -I"${ESYSROOT}"/usr/include/utf8cpp

	local myeconfargs=(
		$(use_enable debug)
		$(usex pch "" --disable-precompiled-headers)
		$(use_enable qt5 qt)
		$(use_with nls gettext)
		$(usex nls "" --with-po4a-translate=false)
		--disable-update-check
		--disable-optimization
		--with-boost="${ESYSROOT}"/usr
		--with-boost-libdir="${ESYSROOT}"/usr/$(get_libdir)
	)

	if use qt5 ; then
		# ac/qt5.m4 finds default Qt version set by qtchooser, bug #532600
		myeconfargs+=(
			--with-moc=$(qt5_get_bindir)/moc
			--with-uic=$(qt5_get_bindir)/uic
			--with-rcc=$(qt5_get_bindir)/rcc
			--with-qmake=$(qt5_get_bindir)/qmake
		)
	fi

	econf "${myeconfargs[@]}"
}

src_compile() {
	rake V=1 -j$(makeopts_jobs) || die
}

src_test() {
	rake V=1 -j$(makeopts_jobs) tests:unit || die
	rake V=1 -j$(makeopts_jobs) tests:run_unit || die
}

src_install() {
	DESTDIR="${D}" rake -j$(makeopts_jobs) install || die

	einstalldocs
	dodoc NEWS.md
	doman doc/man/*.1
}
