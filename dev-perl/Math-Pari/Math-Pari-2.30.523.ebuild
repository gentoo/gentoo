# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ILYAZ
DIST_SECTION=modules
DIST_VERSION=2.030523
inherit perl-module toolchain-funcs

PARI_VER=2.3.5

DESCRIPTION="Perl interface to PARI"
SRC_URI="${SRC_URI}
	https://pari.math.u-bordeaux.fr/pub/pari/OLD/${PARI_VER%.*}/pari-${PARI_VER}.tar.gz"
S_PARI="${WORKDIR}"/pari-${PARI_VER}

SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

# Math::Pari requires that a copy of the pari source in a parallel
# directory to where you build it. It does not need to compile it, but
# it does need to be the same version as is installed, hence the hard
# DEPEND below

src_prepare() {
	# On 64-bit hardware, these files are needed in both the 64/ and 32/
	# directories for the testsuite to pass.
	cd "${S_PARI}"/src/test/ || die

	local t
	for t in analyz compat ellglobalred elliptic galois graph intnum kernel \
		linear nfields number objets ploth polyser program qfbsolve rfrac \
		round4 stark sumiter trans ; do
		i="in/${t}"
		o32="32/${t}"
		o64="64/${t}"

		if [[ -f "${i}" && ! -f "${o32}" ]] ; then
			cp -al "${i}" "${o32}" || die
		fi

		if [[ -f "$i" && ! -f "$o64" ]] ; then
			cp -al "${i}" "${o64}" || die
		fi
	done

	cd "${S_PARI}" || die
	eapply "${FILESDIR}/pari-${PARI_VER}-no-dot-inc.patch"
	cd "${S}" || die

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
