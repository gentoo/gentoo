# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs versionator multiprocessing

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://gitlab.com/mbunkus/mkvtoolnix.git"
	inherit git-r3
else
	SRC_URI="https://mkvtoolnix.download/sources/${P}.tar.xz"
	KEYWORDS="~amd64 ~ppc ~ppc64 x86 ~x86-fbsd ~amd64-linux ~x86-linux"
fi

DESCRIPTION="Tools to create, alter, and inspect Matroska files"
HOMEPAGE="https://mkvtoolnix.download/ https://gitlab.com/mbunkus/mkvtoolnix"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug pch test qt5"

# check NEWS.md for build system changes entries for boost/libebml/libmatroska
# version requirement updates and other packaging info
RDEPEND="
	>=dev-libs/boost-1.49.0:=
	>=dev-libs/libebml-1.3.5:=
	dev-libs/jsoncpp:=
	dev-libs/pugixml
	media-libs/flac
	>=media-libs/libmatroska-1.4.8:=
	media-libs/libogg
	media-libs/libvorbis
	sys-apps/file
	sys-libs/zlib
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtwidgets:5
		dev-qt/qtconcurrent:5
		dev-qt/qtmultimedia:5
	)
"
DEPEND="${RDEPEND}
	dev-ruby/rake
	sys-devel/gettext
	virtual/pkgconfig
	dev-libs/libxslt
	app-text/docbook-xsl-stylesheets
	app-text/po4a
	test? ( dev-cpp/gtest )
"

DOCS="AUTHORS NEWS.md README.md"

pkg_pretend() {
	# https://bugs.gentoo.org/419257
	local ver=4.6
	local msg="You need at least GCC ${ver}.x for C++11 range-based 'for' and nullptr support."
	if ! version_is_at_least ${ver} $(gcc-version); then
		eerror ${msg}
		die ${msg}
	fi
}

src_prepare() {
	default
	[[ ${PV} == "9999" ]] && { ./autogen.sh || die; }
}

src_configure() {
	local myconf

	if use qt5 ; then
		# ac/qt5.m4 finds default Qt version set by qtchooser, bug #532600
		myconf+=(
			--with-moc=/usr/$(get_libdir)/qt5/bin/moc
			--with-uic=/usr/$(get_libdir)/qt5/bin/uic
			--with-rcc=/usr/$(get_libdir)/qt5/bin/rcc
			--with-qmake=/usr/$(get_libdir)/qt5/bin/qmake
		)
	fi

	econf \
		$(use_enable debug) \
		$(use_enable qt5 qt) \
		$(usex pch "" --disable-precompiled-headers) \
		"${myconf[@]}" \
		--disable-update-check \
		--disable-optimization \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		--with-boost="${EPREFIX}"/usr \
		--with-boost-libdir="${EPREFIX}"/usr/$(get_libdir)
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
	doman doc/man/*.1
}
