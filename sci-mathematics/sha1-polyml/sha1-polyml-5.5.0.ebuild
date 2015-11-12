# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit multilib

MY_PN=polyml
MY_P="${MY_PN}-${PV}"

DESCRIPTION="implementation of SHA1 is taken from the GNU coreutils package"
HOMEPAGE="http://isabelle.in.tum.de/"
SRC_URI="http://isabelle.in.tum.de/components/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}/sha1"

LIBDIR="/usr/"$(get_libdir)"/${PN}"

# sci-mathematics/isabelle requires sci-mathematics/sha1-polyml, to avoid
# this warning:
# ### load_lib </usr/bin/libsha1.so> : /usr/bin/libsha1.so: cannot open shared
#  object file: No such file or directory
# ### Using slow ML implementation of SHA1.digest
# sci-mathematics/sha1-polyml supplies the library libsha1.so.  Which
# is the implementation of SHA1 taken from the GNU coreutils package
# as described in the sci-mathematics/sha1-polyml README.  Isabelle
# builds libsha1.so in the contrib/polyml/$ML_PLATFORM directory.
# isabelle dynamically loads libsha1.so as a plugin.  The Isabelle-2012
# linux binary bundle places libsha1.so in the contrib/polyml directory, which
# is referred to as ML_HOME in the Isabelle Pure/General/sha1_polyml.ML source file.
# ML_HOME is /usr/bin on Gentoo, and we want isabelle to depend o sha1-polyml.
# For these reasons isabelle is patched to load it from
# /usr/$(get_libdir)/sha1-polyml/libsha1.so

src_prepare() {
	cp -p "${S}/build" "${S}/build-orig" || die "Could not cp build to build-orig"
	sed -e "s@CFLAGS=\"@CFLAGS=\"${CFLAGS} @g" \
		-e "s@LDFLAGS=\"@LDFLAGS=\"${LDFLAGS} @g" \
		-i "${S}/build" || die "Could not set flags in build"
	cp -p "${S}/build" "${S}/tests" || die "Could not cp build to tests"
	sed -e '/echo "Running tests ..."/,$d' \
		-i "${S}/build" || die "Could not remove run tests from build"
	sed -e '$i\\nexit 0' \
		-i "${S}/build" || die "Could not add exit 0 to build"
	sed -e 's/echo "Running tests ..."/echo "Running tests ..."\necho "Running tests ..."/' \
		-i "${S}/tests" || die "Could not duplicate echo line in tests"
	sed -e '/# building/,/echo "Running tests ..."/d' \
		-i "${S}/tests" || die "Could not remove build from run tests"
	sed -e '$i\\nexit 0' \
		-i "${S}/tests" || die "Could not add exit 0 to tests"
}

src_compile() {
	local arch=$(uname -m)
	local uos=$(uname)
	# Switch to ,, when we switch to EAPI=6.
	#local los=${uos,,}
	local los=$(tr '[:upper:]' '[:lower:]' <<<"${uos}")
	./build "${arch}-${los}" || die "build failed"
}

src_test() {
	./tests "${arch}-${los}" || die "tests failed"
}

src_install() {
	dodoc README
	insinto "/usr/"$(get_libdir)
	dodir ${LIBDIR}
	exeinto ${LIBDIR}
	doexe ${arch}-${los}/libsha1.so
}
