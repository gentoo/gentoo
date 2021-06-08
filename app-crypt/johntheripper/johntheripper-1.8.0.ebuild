# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cuda flag-o-matic toolchain-funcs

MY_PN="john"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="fast password cracker"
HOMEPAGE="https://www.openwall.com/john/"

SRC_URI="https://www.openwall.com/john/j/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
CPU_FLAGS="cpu_flags_x86_mmx cpu_flags_x86_sse2 cpu_flags_x86_avx cpu_flags_x86_xop"
IUSE="custom-cflags openmp ${CPU_FLAGS}"

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}
	!app-crypt/johntheripper-jumbo"

S="${WORKDIR}/${MY_P}"

get_target() {
	if use alpha; then
		echo "linux-alpha"
	elif use amd64; then
		if use cpu_flags_x86_xop; then
			echo "linux-x86-64-xop"
		elif use cpu_flags_x86_avx; then
			echo "linux-x86-64-avx"
		else
			echo "linux-x86-64"
		fi
	elif use ppc; then
		echo "linux-ppc32"
	elif use ppc64; then
		echo "linux-ppc64"
	elif use sparc; then
		echo "linux-sparc"
	elif use x86; then
		if use cpu_flags_x86_xop; then
			echo "linux-x86-xop"
		elif use cpu_flags_x86_avx; then
			echo "linux-x86-avx"
		elif use cpu_flags_x86_sse2; then
			echo "linux-x86-sse2"
		elif use cpu_flags_x86_mmx; then
			echo "linux-x86-mmx"
		else
			echo "linux-x86-any"
		fi
	elif use ppc-macos; then
		echo "macosx-ppc32-altivec"
	elif use x64-macos; then
		echo "macosx-x86-64"
	elif use x86-solaris; then
		echo "solaris-x86-any"
	elif use x86-fbsd; then
		if use cpu_flags_x86_sse2; then
			echo "freebsd-x86-sse2"
		elif use cpu_flags_x86_mmx; then
			echo "freebsd-x86-mmx"
		else
			echo "freebsd-x86-any"
		fi
	elif use amd64-fbsd; then
		echo "freebsd-x86-64"
	else
		echo "generic"
	fi
}

pkg_setup() {
	if use openmp && [[ ${MERGE_TYPE} != binary ]]; then
		tc-has-openmp || die "Please switch to an openmp compatible compiler"
	fi
}

src_prepare() {
	default
}

src_compile() {
	local OMP

	use custom-cflags || strip-flags
	cat <<- EOF >> config.gentoo || die
	#define JOHN_SYSTEMWIDE 1
	#define JOHN_SYSTEMWIDE_HOME "${EPREFIX}/etc/john"
	#define JOHN_SYSTEMWIDE_EXEC "${EPREFIX}/usr/libexec/john"
EOF

	append-flags -fPIC -fPIE
	#gcc-specs-pie && append-ldflags -nopie
	use openmp && OMP="-fopenmp"

	CPP="$(tc-getCXX)" CC="$(tc-getCC)" AS="$(tc-getCC)" LD="$(tc-getCC)"

	emake -C src/ \
		CPP="${CPP}" CC="${CC}" AS="${AS}" LD="${LD}" \
		CFLAGS="-c -Wall -include ../config.gentoo ${CFLAGS} ${OMP}" \
		LDFLAGS="${LDFLAGS} ${OMP}" \
		OPT_NORMAL="" \
		OMPFLAGS="${OMP}" \
		$(get_target)
}

src_test() {
	make -C src/ check
}

src_install() {
	# executables
	dosbin run/john
	newsbin run/mailer john-mailer

	dosym john /usr/sbin/unafs
	dosym john /usr/sbin/unique
	dosym john /usr/sbin/unshadow

	# config files
	insinto /etc/john
	doins run/*.chr run/password.lst
	doins run/*.conf

	# documentation
	dodoc doc/*
}

pkg_postinst() {
	if [ -n "${REPLACING_VERSIONS}" ] && [ "${REPLACING_VERSIONS}" != "1.8.0" ]; then
		ewarn "This package no longer includes jumbo.  If you want jumbo please install app-crypt/johntheripper-jumbo instead."
	fi
}
