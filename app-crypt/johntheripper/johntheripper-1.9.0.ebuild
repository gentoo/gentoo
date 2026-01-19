# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/openwall.asc
inherit eapi9-ver flag-o-matic toolchain-funcs verify-sig

MY_PN="john"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="fast password cracker"
HOMEPAGE="https://www.openwall.com/john/"
SRC_URI="
	https://www.openwall.com/john/k/${MY_P}.tar.xz
	verify-sig? ( https://www.openwall.com/john/k/${MY_P}.tar.xz.sign -> ${MY_P}.tar.xz.sig )
"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~mips ppc ppc64 ~sparc x86"
CPU_FLAGS="cpu_flags_x86_mmx cpu_flags_x86_sse2 cpu_flags_x86_avx cpu_flags_x86_avx2 cpu_flags_x86_avx512f cpu_flags_x86_xop"
IUSE="custom-cflags openmp ${CPU_FLAGS}"

DEPEND="virtual/libcrypt:="
RDEPEND="
	${DEPEND}
	!app-crypt/johntheripper-jumbo
"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-openwall )"

get_target() {
	if use alpha; then
		echo "linux-alpha"
	elif use amd64; then
		if use cpu_flags_x86_avx512f; then
			echo "linux-x86-64-avx512"
		elif use cpu_flags_x86_avx2; then
			echo "linux-x86-64-avx2"
		elif use cpu_flags_x86_xop; then
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
		if use cpu_flags_x86_avx512f; then
			echo "linux-x86-64-avx512"
		elif use cpu_flags_x86_avx2; then
			echo "linux-x86-64-avx2"
		elif use cpu_flags_x86_xop; then
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
	elif use x64-macos; then
		echo "macosx-x86-64"
	else
		echo "generic"
	fi
}

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
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
	emake -C src/ check
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
	if ver_replacing -lt 1.8.0; then
		ewarn "This package no longer includes jumbo.  If you want jumbo please install app-crypt/johntheripper-jumbo instead."
	fi
}
