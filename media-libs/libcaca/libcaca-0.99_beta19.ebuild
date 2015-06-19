# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libcaca/libcaca-0.99_beta19.ebuild,v 1.1 2015/03/18 15:41:26 aballier Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
RUBY_OPTIONAL=yes
USE_RUBY=ruby20

inherit autotools ruby-ng eutils flag-o-matic mono-env multilib java-pkg-opt-2 python-single-r1 multilib-minimal

MY_P=${P/_/.}
DESCRIPTION="A library that creates colored ASCII-art graphics"
HOMEPAGE="http://libcaca.zoy.org/"
SRC_URI="http://libcaca.zoy.org/files/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2 ISC LGPL-2.1 WTFPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="cxx doc imlib java mono ncurses opengl python ruby slang static-libs test truetype X"
REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
	ruby? ( ruby_targets_${USE_RUBY} )
"

COMMON_DEPEND="imlib? ( >=media-libs/imlib2-1.4.6-r2[${MULTILIB_USEDEP}] )
	mono? ( dev-lang/mono )
	ncurses? ( >=sys-libs/ncurses-5.9-r3[${MULTILIB_USEDEP}] )
	opengl? (
		>=virtual/glu-9.0-r1[${MULTILIB_USEDEP}]
		>=virtual/opengl-7.0-r1[${MULTILIB_USEDEP}]
		>=media-libs/freeglut-2.8.1[${MULTILIB_USEDEP}]
		truetype? ( >=media-libs/ftgl-2.1.3_rc5 )
	)
	python? ( ${PYTHON_DEPS} )
	ruby? (  $(ruby_implementations_depend) )
	slang? ( >=sys-libs/slang-2.2.4-r1[${MULTILIB_USEDEP}] )
	X? ( >=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}] >=x11-libs/libXt-1.1.4[${MULTILIB_USEDEP}] )"
RDEPEND="${COMMON_DEPEND}
	java? ( >=virtual/jre-1.5 )"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	doc? (
		app-doc/doxygen
		virtual/latex-base
		>=dev-texlive/texlive-fontsrecommended-2012
		>=dev-texlive/texlive-latexextra-2012
		dev-tex/xcolor
	)
	java? ( >=virtual/jdk-1.5 )
	test? ( dev-util/cppunit )"

S=${WORKDIR}/${MY_P}

DOCS=( AUTHORS ChangeLog NEWS NOTES README THANKS )

pkg_setup() {
	use python && python-single-r1_pkg_setup
	java-pkg-opt-2_pkg_setup
	use mono && mono-env_pkg_setup
}

src_unpack() {
	default
}

src_prepare() {
	sed -i -e '/doxygen_tests = check-doxygen/d' test/Makefile.am || die #339962

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

	# Removed 'has_version '>=dev-texlive/texlive-latex-2013' &&' that prefixed this
	# patch before wrt #517474
	epatch "${FILESDIR}"/${PN}-0.99_beta18-latex_hacks.patch

	# fix out of source tests
	epatch "${FILESDIR}"/${PN}-0.99_beta18-fix-tests.patch

	eautoreconf

	java-pkg-opt-2_src_prepare
}

multilib_src_configure() {
	if multilib_is_native_abi; then
		if use java; then
			export JAVACFLAGS="$(java-pkg_javac-args)"
			export JAVA_CFLAGS="$(java-pkg_get-jni-cflags)"
		fi

		use mono && export CSC="$(type -P gmcs)" #329651
		export VARTEXFONTS="${T}/fonts" #44128
		use ruby && use ruby_targets_${USE_RUBY} && export RUBY=$(ruby_implementation_command ${USE_RUBY})
	fi

	ECONF_SOURCE="${S}" \
		econf \
			$(use_enable static-libs static) \
			$(use_enable slang) \
			$(use_enable ncurses) \
			$(use_enable X x11) $(use_with X x) --x-libraries=/usr/$(get_libdir) \
			$(use_enable opengl gl) \
			$(use_enable cxx) \
			$(use_enable imlib imlib2) \
			$(use_enable test cppunit) \
			$(multilib_native_use_enable java) \
			$(multilib_native_use_enable ruby) \
			$(multilib_native_use_enable python) \
			$(multilib_native_use_enable mono csharp) \
			$(multilib_native_use_enable doc)
}

multilib_src_compile() {
	local _java_makeopts
	use java && _java_makeopts="-j1" #480864
	emake V=1 ${_java_makeopts}
}

multilib_src_test() {
	emake V=1 -j1 check
}

multilib_src_install() {
	emake V=1 DESTDIR="${D}" install

	if multilib_is_native_abi && use java; then
		java-pkg_newjar java/libjava.jar
	fi
}

multilib_src_install_all() {
	einstalldocs
	rm -rf "${D}"/usr/share/java
	prune_libtool_files --modules
}
