# Copyright 2012-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal toolchain-funcs

# Different date format used upstream.
RE2_VER=${PV#0.}
RE2_VER=${RE2_VER//./-}

DESCRIPTION="An efficient, principled regular expression library"
HOMEPAGE="https://github.com/google/re2"
SRC_URI="https://github.com/google/re2/archive/${RE2_VER}.tar.gz -> re2-${RE2_VER}.tar.gz"
S="${WORKDIR}/re2-${RE2_VER}"

LICENSE="BSD"
# NOTE: Always run libre2 through abi-compliance-checker!
# https://abi-laboratory.pro/tracker/timeline/re2/
SONAME="11"
SLOT="0/${SONAME}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc64 ~riscv ~sparc ~x86"
IUSE="benchmark icu test test-full"
REQUIRED_USE="
	test-full? ( test )
"
RESTRICT="!test? ( test )"

BDEPEND="virtual/pkgconfig"
RDEPEND="
	>=dev-cpp/abseil-cpp-20240116.2-r3:=
	benchmark? ( dev-cpp/benchmark )
	icu? ( dev-libs/icu:0=[${MULTILIB_USEDEP}] )
"
DEPEND="
	${RDEPEND}
	test? (	dev-cpp/gtest[${MULTILIB_USEDEP}] )
"

DOCS=( README doc/syntax.txt )
HTML_DOCS=( doc/syntax.html )

src_prepare() {
	default
	grep -q "^SONAME=${SONAME}\$" Makefile || die "SONAME mismatch"
	if use icu; then
		sed -i -e 's:^# \(\(CC\|LD\)ICU=.*\):\1:' Makefile || die
	fi
	multilib_copy_sources
}

src_configure() {
	tc-export AR CXX
}

multilib_src_compile() {
	emake SONAME="${SONAME}" shared
	if multilib_is_native_abi && use benchmark; then
		emake benchmark
	fi
}

multilib_src_test() {
	if use test-full; then
		emake shared-bigtest
	else
		emake shared-test
	fi
}

multilib_src_install() {
	emake SONAME="${SONAME}" DESTDIR="${D}" prefix="${EPREFIX}/usr" libdir="\$(exec_prefix)/$(get_libdir)" shared-install
	if multilib_is_native_abi && use benchmark; then
		newbin obj/test/regexp_benchmark re2-bench
	fi
}
