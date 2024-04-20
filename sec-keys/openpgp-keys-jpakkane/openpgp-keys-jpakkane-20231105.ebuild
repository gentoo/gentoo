# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by Jussi Pakkanen"
HOMEPAGE="https://github.com/jpakkane"
SRC_URI="https://github.com/jpakkane.gpg -> jpakkane-${PV}.gpg"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

src_install() {
	insinto /usr/share/openpgp-keys
	newins "${DISTDIR}"/jpakkane-${PV}.gpg jpakkane.gpg
}
