# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP key of Jay Berkenbilt (QPDF maintainer)"
HOMEPAGE="https://github.com/jberkenbilt/"
SRC_URI="https://github.com/jberkenbilt.gpg -> jberkenbilt.asc"
S=${WORKDIR}

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

src_install() {
	insinto /usr/share/openpgp-keys
	doins "${DISTDIR}/jberkenbilt.asc"
}
