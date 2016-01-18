# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

# Upstream only installs a static library. The original antlr ebuild
# built a shared library manually, which isn't so great either. This
# ebuild applies libtool instead and therefore an autoreconf is
# required. A couple of errors concerning tr have been seen but the
# final result still looks good. This also sidesteps bug #554344 plus
# the need to call einstall.
AUTOTOOLS_AUTORECONF=1

inherit eutils autotools-multilib

MY_P="${PN%-cpp}-${PV}"
DESCRIPTION="The ANTLR 2 C++ Runtime"
HOMEPAGE="http://www.antlr2.org/"
SRC_URI="http://www.antlr2.org/download/${MY_P}.tar.gz"
LICENSE="public-domain"
SLOT="2"
KEYWORDS="~amd64 ~arm ppc ~x86"
IUSE="doc examples static-libs"
RESTRICT="test" # No tests but test target blows up!

DEPEND="doc? ( app-doc/doxygen )"
RDEPEND="!!dev-java/antlr:0[cxx]"

S="${WORKDIR}/${MY_P}"
DOCS=( lib/cpp/AUTHORS lib/cpp/ChangeLog lib/cpp/README lib/cpp/TODO )

src_prepare() {
	epatch "${FILESDIR}"/${PV}-{gcc,libtool}.patch

	mv -v configure.in configure.ac || die
	mv -v aclocal.m4 acinclude.m4 || die

	# These silly test -z lines break badly under recent autoconfs.
	sed -i '/AC_PATH_PROG/s/test -z "\$[^"]*" *&& *//' configure.ac || die

	# Delete build files from examples.
	find examples -name Makefile.in -delete || die

	# Fix make invocations. See bug #256880.
	find -name "*.in" -exec sed -i 's/@MAKE@/$(MAKE)/g' {} + || die

	# Turn Makefile.in files into libtool-style Makefile.am
	# files. Countable.hpp is actually missing.
	local HPP=$(grep -E -o "\w+\.hpp" lib/cpp/antlr/Makefile.in | grep -v "Countable\.hpp" | tr "\n" " " || die)
	local CPP=$(grep -E -o "\w+\.cpp" lib/cpp/src/Makefile.in | tr "\n" " " || die)

	cat <<EOF > lib/cpp/antlr/Makefile.am || die
antlr_includedir = \$(includedir)/antlr
antlr_include_HEADERS = ${HPP}
EOF

	cat <<EOF > lib/cpp/src/Makefile.am || die
AM_CPPFLAGS = -I\$(abs_top_srcdir)/lib/cpp
lib_LTLIBRARIES = libantlr.la
libantlr_la_LDFLAGS = -version-info 2
libantlr_la_SOURCES = ${CPP}
EOF

	autotools-multilib_src_prepare
}

multilib_src_configure() {
	local myeconfargs=(
		--disable-csharp
		--enable-cxx
		--disable-examples
		--disable-java
		--disable-python
		--enable-verbose
	)

	autotools-utils_src_configure
}

src_compile() {
	autotools-multilib_src_compile

	if use doc; then
		cd "${S}/lib/cpp" || die
		doxygen -u doxygen.cfg || die
		doxygen doxygen.cfg || die
	fi
}

multilib_src_install() {
	# We only care about the C++ stuff.
	emake -C lib/cpp install DESTDIR="${D}"
}

src_install() {
	autotools-multilib_src_install

	cd "${S}" || die
	use doc && dohtml -r lib/cpp/gen_doc/html/

	if use examples; then
		docinto examples
		dodoc -r examples/cpp/*
	fi
}
