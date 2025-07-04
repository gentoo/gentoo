# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic multiprocessing prefix qmake-utils toolchain-funcs xdg

if [[ ${PV} == *9999 ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://codeberg.org/mbunkus/mkvtoolnix.git"
	EGIT_SUBMODULES=()
else
	inherit verify-sig

	SRC_URI="
		https://mkvtoolnix.download/sources/${P}.tar.xz
		verify-sig? ( https://mkvtoolnix.download/sources/${P}.tar.xz.sig )
	"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"

	VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/mkvtoolnix.asc"
fi

DESCRIPTION="Tools to create, alter, and inspect Matroska files"
HOMEPAGE="https://mkvtoolnix.download/ https://codeberg.org/mbunkus/mkvtoolnix"

LICENSE="GPL-2"
SLOT="0"
IUSE="dbus debug dvd gui nls pch test"
# bug #951192
REQUIRED_USE="dbus? ( gui )"
RESTRICT="!test? ( test )"

# check NEWS.md for build system changes entries for boost/libebml/libmatroska
# version requirement updates and other packaging info
RDEPEND="
	dev-libs/boost:=
	dev-libs/gmp:=
	>=dev-libs/libebml-1.4.5:=
	>=dev-libs/libfmt-8.0.1:=
	>=dev-libs/pugixml-1.11
	>=dev-qt/qtbase-6.2:6[dbus?]
	media-libs/flac:=
	>=media-libs/libmatroska-1.7.1:=
	media-libs/libogg
	media-libs/libvorbis
	sys-libs/zlib
	dvd? ( media-libs/libdvdread:= )
	gui? (
		app-text/cmark:0=
		>=dev-qt/qtbase-6.2:6[concurrent,gui,network,widgets]
		>=dev-qt/qtmultimedia-6.2:6
		>=dev-qt/qtsvg-6.2:6
	)
"
DEPEND="${RDEPEND}
	>=dev-cpp/nlohmann_json-3.11.3
	>=dev-libs/utfcpp-3.1.2
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

if [[ ${PV} != *9999 ]] ; then
	BDEPEND+="verify-sig? ( sec-keys/openpgp-keys-mkvtoolnix )"
fi

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		# bug #927497
		# the compiler used for qtbase affects what compiler arguments qmake will use
		if tc-is-gcc; then
			expected_spec="linux-g++"
		elif tc-is-clang; then
			expected_spec="linux-clang"
		fi

		if [[ ${expected_spec} != $(qmake6 -query QMAKE_SPEC) ]]; then
			if tc-is-gcc; then
				eerror "Detected non-gcc qmake spec but current compiler is gcc."
			elif tc-is-clang; then
				eerror "Detected non-clang qmake spec but current compiler is clang."
			fi
			eerror "Compiler mismatch: dev-qt/qtbase:6 and ${CATEGORY}/${PN} have to use the same toolchain https://bugs.gentoo.org/927497"
		fi
	fi
}

src_prepare() {
	default

	if [[ ${PV} == *9999 ]]; then
		./autogen.sh || die
	fi

	# bug #692018
	sed -i -e 's/pandoc/diSaBlEd/' ac/pandoc.m4 || die

	# bug #928463
	hprefixify "${S}/ac/ax_docbook.m4"

	eautoreconf

	# remove bundled libs
	rm -r lib/{fmt,libebml,libmatroska,nlohmann-json,pugixml,utf8-cpp} || die
}

src_configure() {
	# bug #692322, use system dev-libs/utfcpp
	append-cppflags -I"${ESYSROOT}"/usr/include/utf8cpp

	local myeconfargs=(
		$(use_enable dbus)
		$(use_enable debug)
		$(usex pch "" --disable-precompiled-headers)
		$(use_enable gui)
		$(use_with dvd dvdread)
		$(use_with nls gettext)
		#$(use_with nls po4a)
		--disable-update-check
		--disable-optimization
		--with-boost="${ESYSROOT}"/usr
		--with-boost-libdir="${ESYSROOT}"/usr/$(get_libdir)

		# Qt (of some version) is always needed, even for non-GUI builds,
		# to do e.g. MIME detection. See e.g. bug #844097.
		# But most of the Qt deps are conditional on a GUI build.
		--with-qmake6="$(qt6_get_bindir)"/qmake
	)

	# Work around bug #904710.
	use nls || export ac_cv_path_PO4A=

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
