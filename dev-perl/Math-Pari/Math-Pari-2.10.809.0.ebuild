# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ILYAZ
DIST_SECTION=modules
DIST_VERSION=2.01080900
DIST_A_EXT=zip
inherit perl-module toolchain-funcs

PARI_VER=2.3.5

DESCRIPTION="Perl interface to PARI"
SRC_URI="${SRC_URI}
	http://pari.math.u-bordeaux.fr/pub/pari/unix/pari-${PARI_VER}.tar.gz"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

# Math::Pari requires that a copy of the pari source in a parallel
# directory to where you build it. It does not need to compile it, but
# it does need to be the same version as is installed, hence the hard
# DEPEND below
RDEPEND="~sci-mathematics/pari-${PARI_VER}"
DEPEND="${RDEPEND}
	app-arch/unzip
"

S_PARI=${WORKDIR}/pari-${PARI_VER}

PATCHES=(
	"${FILESDIR}/no-flto.patch"
	"${FILESDIR}/${P}-no-dot-inc.patch"
)
src_prepare() {
	# On 64-bit hardware, these files are needed in both the 64/ and 32/
	# directories for the testsuite to pass.
	cd "${S_PARI}"/src/test/
	for t in analyz compat ellglobalred elliptic galois graph intnum kernel \
		linear nfields number objets ploth polyser program qfbsolve rfrac \
		round4 stark sumiter trans ; do
		i="in/${t}"
		o32="32/${t}"
		o64="64/${t}"
		[ -f "$i" -a ! -f "$o32" ] && cp -al "$i" "$o32"
		[ -f "$i" -a ! -f "$o64" ] && cp -al "$i" "$o64"
	done
	cd "${S_PARI}"
	eapply "${FILESDIR}/pari-${PARI_VER}-no-dot-inc.patch"
	cd "${S}"
	perl-module_src_prepare
}

src_configure() {
	# Unfortunately the assembly routines math-pari has for SPARC do not appear
	# to be working at current.  Perl cannot test math-pari or anything that
	# pulls in the math-pari module as DynaLoader cannot load the resulting
	# .so files math-pari generates.  As such, we have to use the generic
	# non-machine specific assembly methods here.
	use sparc && myconf="${myconf} machine=none"

	perl-module_src_configure
}

src_compile() {
	emake AR="$(tc-getAR)" OTHERLDFLAGS="${LDFLAGS}"
}
