# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by Eli Schwartz"
HOMEPAGE="https://github.com/eli-schwartz"
SRC_URI="https://github.com/eli-schwartz.gpg -> eli-schwartz-${PV}.gpg"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

src_install() {
	insinto /usr/share/openpgp-keys
	newins "${DISTDIR}"/eli-schwartz-${PV}.gpg eschwartz.gpg
}
