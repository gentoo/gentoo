# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP key of Jay Berkenbilt (QPDF maintainer)"
HOMEPAGE="https://github.com/jberkenbilt/"
SRC_URI="https://github.com/jberkenbilt.gpg -> jberkenbilt.asc"
S=${WORKDIR}

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ppc64 ~riscv ~s390 sparc ~x86 ~amd64-linux ~x86-linux"

src_install() {
	insinto /usr/share/openpgp-keys
	doins "${DISTDIR}/jberkenbilt.asc"
}
