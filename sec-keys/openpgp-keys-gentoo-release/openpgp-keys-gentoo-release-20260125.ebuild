# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used for Gentoo releases (snapshots, stages)"
HOMEPAGE="https://www.gentoo.org/downloads/signatures/"
# https://dev.gentoo.org/~mgorny/dist/openpgp-keys/gentoo-release.asc.${PV}.gz
SRC_URI="
	https://dev.gentoo.org/~sam/dist/sec-keys/${PN}/gentoo-release.asc.${PV}.gz
	test? (
		https://dev.gentoo.org/~mgorny/dist/openpgp-keys/gentoo-release-test-sigs-20190224.tar.gz
	)
"
S=${WORKDIR}

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		|| (
			app-crypt/gnupg[alternatives(-)]
			>=app-crypt/freepg-2.5.12_p1-r1
		)
	)
"

# Keys included:
# DCD05B71EAB94199527F44ACDB6B8C1F96D8BF6D
# D99EAC7379A850BCE47DA5F29E6438C817072058
# 13EBBDBEDE7A12775DFDB1BABB572E0E2D182910
# EF9538C9E8E64311A52CDEDFA13D0EF1914E7A72

src_test() {
	local old_umask=$(umask)
	umask 077

	local -x GNUPGHOME=${T}/.gnupg
	mkdir "${GNUPGHOME}" || die
	einfo "Importing keys ..."
	gpg-reference --import "gentoo-release.asc.${PV}" || die "Key import failed"

	local f
	for f in gentoo-release-test-sigs*/*.asc; do
		einfo "Testing ${f##*/} ..."
		gpg-reference -q --trust-model always --verify "${f}" || die "Verification failed on ${f}"
	done

	umask "${old_umask}"
}

src_install() {
	insinto /usr/share/openpgp-keys
	newins "gentoo-release.asc.${PV}" gentoo-release.asc
}
