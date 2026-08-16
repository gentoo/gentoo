# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools edo flag-o-matic toolchain-funcs

MY_PV="${PV%%_p*}"
PATCH_LEVEL="${PV##*_p}"

DESCRIPTION="Utility for opening arj archives"
HOMEPAGE="https://arj.sourceforge.net/"
SRC_URI="
	mirror://debian/pool/main/a/arj/arj_${MY_PV}.orig.tar.gz
	mirror://debian/pool/main/a/arj/arj_${MY_PV}-${PATCH_LEVEL}.debian.tar.xz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86"

DOCS=( doc/compile.txt doc/debug.txt doc/glossary.txt doc/rev_hist.txt doc/xlation.txt )

src_prepare() {
	PATCHES=(
		$(sed -e 's:^:../debian/patches/:' "${WORKDIR}"/debian/patches/series || die)

		"${FILESDIR}"/arj-3.10.22-implicit-declarations.patch
		"${FILESDIR}"/arj-3.10.22-darwin.patch
		"${FILESDIR}"/arj-3.10.22-aligned-pointers.patch
	)

	default

	cd gnu || die 'failed to change to the "gnu" directory'
	echo -n "" > stripgcc.lnk || die "failed to disable stripgcc.lnk"
	# Fix typo in configure in a (non-)comment line
	sed -i -e '/^dns Unconditionally align pointers$/s:dns:dnl:' configure.in || die

	eautoreconf
}

src_configure() {
	# Needed for keeping intergrity_identifier around so that postproc can find it later
	# GCC defaults to enabling it, Clang doesn't.
	# bug #509700
	append-cflags -fkeep-static-consts

	# Debian patches assume this is set. Can be updated with "date +%s"
	export SOURCE_DATE_EPOCH="1737318540"

	tc-export CC # Uses autoconf but not automake.
	export CC_FOR_BUILD="$(tc-getBUILD_CC)"

	if tc-is-cross-compiler; then
		export CFLAGS_FOR_BUILD="${BUILD_CFLAGS}"
	else
		export CFLAGS_FOR_BUILD="${CFLAGS}"
	fi

	cd gnu || die 'failed to change to the "gnu" directory'
	econf
}

src_test() {
	# debian includes a test script. why not use it?
	local -x AUTOPKGTEST_TMP="${T}/debian-test"

	local -x PATH="${S}/linux-gnu/en/rs/arj/:${PATH}"

	edo "${WORKDIR}"/debian/tests/test-command
}
