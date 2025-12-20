# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic toolchain-funcs

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
KEYWORDS="amd64 ~arm ~arm64 ppc ppc64 ~sparc x86"

PATCHES=(
	# get order of patches from series file. otherwise the order is wrong :/
	"${WORKDIR}"/debian/patches/001_arches_align.patch
	"${WORKDIR}"/debian/patches/002_no_remove_static_const.patch
	"${WORKDIR}"/debian/patches/003_64_bit_clean.patch
	"${WORKDIR}"/debian/patches/004_parallel_build.patch
	"${WORKDIR}"/debian/patches/005_use_system_strnlen.patch
	"${WORKDIR}"/debian/patches/006_use_safe_strcpy.patch
	"${WORKDIR}"/debian/patches/hurd_no_fcntl_getlk.patch
	"${WORKDIR}"/debian/patches/security_format.patch
	"${WORKDIR}"/debian/patches/doc_refer_robert_k_jung.patch
	"${WORKDIR}"/debian/patches/gnu_build_fix.patch
	"${WORKDIR}"/debian/patches/gnu_build_flags.patch
	"${WORKDIR}"/debian/patches/gnu_build_strip.patch
	"${WORKDIR}"/debian/patches/gnu_build_pie.patch
	"${WORKDIR}"/debian/patches/self_integrity_64bit.patch
	"${WORKDIR}"/debian/patches/security-afl.patch
	"${WORKDIR}"/debian/patches/security-traversal-dir.patch
	"${WORKDIR}"/debian/patches/security-traversal-symlink.patch
	"${WORKDIR}"/debian/patches/out-of-bounds-read.patch
	"${WORKDIR}"/debian/patches/remove_build_date.patch
	"${WORKDIR}"/debian/patches/reproducible_help_archive.patch
	"${WORKDIR}"/debian/patches/gnu_build_cross.patch
	"${WORKDIR}"/debian/patches/fix-time_t-usage.patch
	"${WORKDIR}"/debian/patches/gnu_build_fix_autoreconf.patch
	"${WORKDIR}"/debian/patches/fix-implicit-func.patch
	"${FILESDIR}"/arj-3.10.22-implicit-declarations.patch
	"${FILESDIR}"/arj-3.10.22-darwin.patch
)

DOCS=( doc/compile.txt doc/debug.txt doc/glossary.txt doc/rev_hist.txt doc/xlation.txt )

src_prepare() {
	default

	cd gnu || die 'failed to change to the "gnu" directory'
	echo -n "" > stripgcc.lnk || die "failed to disable stripgcc.lnk"

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

	"${WORKDIR}"/debian/tests/test-command || die
}
