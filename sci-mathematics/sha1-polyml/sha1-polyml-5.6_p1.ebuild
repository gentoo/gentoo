# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit multilib toolchain-funcs

MY_PN="polyml"
MY_PV="5.6-1"
MY_P="${MY_PN}-${MY_PV}"

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

src_compile() {
	$(tc-getCC) \
		${CPPFLAGS} ${CFLAGS} ${LDFLAGS} -I. -fPIC -shared \
		-o libsha1.so sha1.c || die "compile libsha1.so failed"
	$(tc-getCC) \
		${CPPFLAGS} ${CFLAGS} ${LDFLAGS} -I. \
		-o test_sha1 test_sha1.c -ldl || die "compile test_sha1 failed"
}

src_test() {
	./test_sha1 ./libsha1.so || die "tests failed"
}

src_install() {
	dodoc README
	local ld="${ROOT}usr/"$(get_libdir)"/${PN}"
	dodir ${ld}
	exeinto ${ld}
	doexe libsha1.so
}
