# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

RUBY_OPTIONAL=yes
#USE_RUBY=ruby20

inherit autotools ruby-ng flag-o-matic java-pkg-opt-2 mono-env toolchain-funcs multilib-minimal

MY_P=${P/_/.}
DESCRIPTION="A library that creates colored ASCII-art graphics"
HOMEPAGE="http://libcaca.zoy.org/"
SRC_URI="http://libcaca.zoy.org/files/${PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2 ISC LGPL-2.1 WTFPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="cxx doc imlib java mono ncurses opengl ruby slang static-libs test truetype X"
RESTRICT="!test? ( test )"

# ruby? ( ruby_targets_${USE_RUBY} )
REQUIRED_USE=""

# ruby? (  $(ruby_implementations_depend) )
DEPEND="
	imlib? ( >=media-libs/imlib2-1.4.6-r2[${MULTILIB_USEDEP}] )
	mono? ( dev-lang/mono )
	ncurses? ( >=sys-libs/ncurses-5.9-r3:0=[${MULTILIB_USEDEP}] )
	opengl? (
		>=virtual/glu-9.0-r1[${MULTILIB_USEDEP}]
		>=virtual/opengl-7.0-r1[${MULTILIB_USEDEP}]
		>=media-libs/freeglut-2.8.1[${MULTILIB_USEDEP}]
		truetype? ( >=media-libs/ftgl-2.1.3_rc5 )
	)
	slang? ( >=sys-libs/slang-2.2.4-r1[${MULTILIB_USEDEP}] )
	X? (
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXt-1.1.4[${MULTILIB_USEDEP}]
	)
"
RDEPEND="java? ( >=virtual/jre-1.5 )"
BDEPEND="
	virtual/pkgconfig
	doc? (
		app-doc/doxygen
		virtual/latex-base
		>=dev-texlive/texlive-fontsrecommended-2012
		>=dev-texlive/texlive-latexextra-2012
		dev-texlive/texlive-latexrecommended
	)
	java? ( >=virtual/jdk-1.5 )
	test? ( dev-util/cppunit )
"

DOCS=( AUTHORS ChangeLog NEWS NOTES README THANKS )

PATCHES=(
	# Removed 'has_version '>=dev-texlive/texlive-latex-2013' &&' that prefixed this
	# patch before wrt #517474
	"${FILESDIR}"/${PN}-0.99_beta18-latex_hacks.patch
	# Fix out of source tests
	"${FILESDIR}"/${PN}-0.99_beta18-fix-tests.patch
)

pkg_setup() {
	java-pkg-opt-2_pkg_setup
	use mono && mono-env_pkg_setup
}

src_unpack() {
	default
}

src_prepare() {
	# bug #339962
	sed -i -e '/doxygen_tests = check-doxygen/d' test/Makefile.am || die

	sed -i \
		-e 's:-g -O2 -fno-strength-reduce -fomit-frame-pointer::' \
		-e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' \
		configure.ac || die

	sed -i \
		-e 's:$(JAVAC):$(JAVAC) $(JAVACFLAGS):' \
		-e 's:libcaca_java_la_CPPFLAGS =:libcaca_java_la_CPPFLAGS = -I$(top_srcdir)/caca:' \
		java/Makefile.am || die

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

	default
	eautoreconf

	java-pkg-opt-2_src_prepare
}

multilib_src_configure() {
	if multilib_is_native_abi; then
		if use java; then
			export JAVACFLAGS="$(java-pkg_javac-args)"
			export JAVA_CFLAGS="$(java-pkg_get-jni-cflags)"
		fi

		# bug #44128
		export VARTEXFONTS="${T}/fonts"

		# bug #329651
		use mono && export CSC="$(type -P gmcs)"
		use ruby && use ruby_targets_${USE_RUBY} && export RUBY=$(ruby_implementation_command ${USE_RUBY})
	fi

	local myeconfargs=(
		$(use_enable static-libs static)
		$(use_enable slang)
		$(use_enable ncurses)
		$(use_enable X x11)
		$(use_with X x)
		--x-libraries=/usr/$(get_libdir)
		$(use_enable opengl gl)
		$(use_enable cxx)
		$(use_enable imlib imlib2)
		$(use_enable test cppunit)
		$(multilib_native_use_enable java)
		$(multilib_native_use_enable ruby)
		--disable-python
		$(multilib_native_use_enable mono csharp)
		$(multilib_native_use_enable doc)
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_compile() {
	local _java_makeopts

	# bug #480864
	use java && _java_makeopts="-j1"
	emake V=1 ${_java_makeopts}
}

multilib_src_test() {
	emake V=1 -j1 check
}

multilib_src_install() {
	emake V=1 DESTDIR="${D}" install

	# Note: broken, see bug #508564 and bug #773913
	if multilib_is_native_abi && use java; then
		java-pkg_newjar java/libjava.jar
	fi
}

multilib_src_install_all() {
	einstalldocs

	rm -rf "${ED}"/usr/share/java || die

	find "${ED}" -name '*.la' -delete || die
}
