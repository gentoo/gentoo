# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenPGP keys used for Gentoo releases (snapshots, stages)"
HOMEPAGE="https://www.gentoo.org/downloads/signatures/"
SRC_URI="https://dev.gentoo.org/~mgorny/dist/openpgp-keys/gentoo-release.asc.${PV}.gz
	test? ( https://dev.gentoo.org/~mgorny/dist/openpgp-keys/gentoo-release-test-sigs-20190224.tar.gz )"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 ~riscv s390 sh sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( app-crypt/gnupg )"

S=${WORKDIR}

src_test() {
	local old_umask=$(umask)
	umask 077

	local -x GNUPGHOME=${T}/.gnupg
	mkdir "${GNUPGHOME}" || die
	einfo "Importing keys ..."
	gpg --import "gentoo-release.asc.${PV}" || die "Key import failed"

	local f
	for f in gentoo-release-test-sigs*/*.asc; do
		einfo "Testing ${f##*/} ..."
		gpg -q --trust-model always --verify "${f}" || die "Verification failed on ${f}"
	done

	umask "${old_umask}"
}

src_install() {
	insinto /usr/share/openpgp-keys
	newins "gentoo-release.asc.${PV}" gentoo-release.asc
}
