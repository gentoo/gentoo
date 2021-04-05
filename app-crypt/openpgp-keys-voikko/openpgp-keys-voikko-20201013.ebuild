# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenPGP keys used to sign voikko* packages"
HOMEPAGE="https://voikko.puimula.org/"
SRC_URI="http://keys.gnupg.net/pks/lookup?op=get&search=0x3D309B604AE3942E -> 4AE3942E.asc.html"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

S="${WORKDIR}"

src_install() {
	insinto /usr/share/openpgp-keys
	newins - voikko.asc < <(awk '/-----BEGIN PGP PUBLIC KEY BLOCK-----/,/-----END PGP PUBLIC KEY BLOCK-----/' ${DISTDIR}/4AE3942E.asc.html || die)
}
