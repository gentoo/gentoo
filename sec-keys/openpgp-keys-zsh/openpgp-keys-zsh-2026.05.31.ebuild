# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="PGP keys used to sign ZSH releases"
HOMEPAGE="https://www.zsh.org/"
SRC_URI="https://www.zsh.org/pub/zsh-keyring.asc -> zsh-keyring-${PV}.asc"
S=${WORKDIR}

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"

src_unpack() {
	:
}

src_install() {
	insinto /usr/share/openpgp-keys
	newins "${DISTDIR}/zsh-keyring-${PV}.asc" zsh-keyring.asc
}
