# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

RUBY_OPTIONAL=yes

inherit autotools ruby-ng flag-o-matic toolchain-funcs multilib-minimal

MY_P=${P/_/.}
DESCRIPTION="A library that creates colored ASCII-art graphics"
HOMEPAGE="http://libcaca.zoy.org/"
SRC_URI="http://libcaca.zoy.org/files/${PN}/${MY_P}.tar.gz"
S="${WORKDIR}/all/${MY_P}"

LICENSE="GPL-2 ISC LGPL-2.1 WTFPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="doc imlib ncurses opengl ruby slang static-libs test truetype X"
RESTRICT="!test? ( test )"

REQUIRED_USE=""

DEPEND="
	imlib? ( >=media-libs/imlib2-1.4.6-r2[${MULTILIB_USEDEP}] )
	ncurses? ( >=sys-libs/ncurses-5.9-r3:0=[${MULTILIB_USEDEP}] )
	opengl? (
		>=virtual/glu-9.0-r1[${MULTILIB_USEDEP}]
		>=virtual/opengl-7.0-r1[${MULTILIB_USEDEP}]
		>=media-libs/freeglut-2.8.1[${MULTILIB_USEDEP}]
		truetype? ( >=media-libs/ftgl-2.1.3_rc5 )
	)
	slang? ( >=sys-libs/slang-2.2.4-r1 )
	X? (
		>=x11-libs/libX11-1.6.2
		>=x11-libs/libXt-1.1.4
	)
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? (
		app-doc/doxygen
		virtual/latex-base
		>=dev-texlive/texlive-fontsrecommended-2012
		>=dev-texlive/texlive-latexextra-2012
		dev-texlive/texlive-latexrecommended
	)
	test? ( dev-util/cppunit )
"

DOCS=( AUTHORS ChangeLog NEWS NOTES README THANKS )

PATCHES=(
	# Fix out of source tests
	"${FILESDIR}"/${PN}-0.99_beta18-fix-tests.patch
	# Debian patches
	"${FILESDIR}/CVE-2018-20544.patch"
	"${FILESDIR}/CVE-2018-20545+20547+20549.patch"
	"${FILESDIR}/CVE-2018-20546+20547.patch"
	"${FILESDIR}/canvas-fix-an-integer-overflow-in-caca_resize.patch"
	"${FILESDIR}/Fix-a-problem-in-the-caca_resize-overflow-detection-.patch"
	"${FILESDIR}/100_doxygen.diff"
	# Fix doxygen docs install, bug 543870
	"${FILESDIR}/fix-css-path.patch"
)

pkg_setup() {
	use ruby && ruby-ng_pkg_setup
}

src_prepare() {
	# bug #339962
	sed -i -e '/doxygen_tests = check-doxygen/d' test/Makefile.am || die

	sed -i \
		-e 's:-g -O2 -fno-strength-reduce -fomit-frame-pointer::' \
		-e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' \
		configure.ac || die

	if ! use truetype; then
		sed -i -e '/PKG_CHECK_MODULES/s:ftgl:dIsAbLe&:' configure.ac || die
	fi

	if use imlib && ! use X; then
		append-cflags -DX_DISPLAY_MISSING
	fi

	# bug #653400
	append-cxxflags -std=c++11

	# bug #601902
	append-libs "$($(tc-getPKG_CONFIG) --libs ncurses)"

	# fix docs install path, bug 543870#c14
	sed -i "s/libcaca-dev/${PF}/g" doc/Makefile.am || die

	default
	eautoreconf
}

multilib_src_configure() {
	if multilib_is_native_abi; then
		# bug #44128
		export VARTEXFONTS="${T}/fonts"

		# bug #329651
		use ruby && use ruby_targets_${USE_RUBY} && export RUBY=$(ruby_implementation_command ${USE_RUBY})
	fi

	local myeconfargs=(
		$(use_enable static-libs static)
		$(multilib_native_use_enable slang)
		$(multilib_native_use_enable ncurses)
		$(multilib_native_use_enable X x11)
		$(multilib_native_use_with X x)
		--x-libraries=/usr/$(get_libdir)
		$(use_enable opengl gl)
		--enable-cxx
		$(use_enable imlib imlib2)
		$(use_enable test cppunit)
		--disable-java
		$(multilib_native_use_enable ruby)
		--disable-python
		--disable-csharp
		$(multilib_native_use_enable doc)
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_compile() {
	emake V=1
}

multilib_src_test() {
	emake V=1 -j1 check
}

multilib_src_install_all() {
	einstalldocs

	find "${ED}" -name '*.la' -delete || die
}
