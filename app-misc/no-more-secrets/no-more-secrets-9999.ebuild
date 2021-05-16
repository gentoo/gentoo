# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/bartobri/no-more-secrets.git"
	inherit git-r3
else
	SRC_URI="https://github.com/bartobri/no-more-secrets/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Recreate decrypting text from 1992 movie 'Sneakers'"
HOMEPAGE="https://github.com/bartobri/no-more-secrets"

LICENSE="GPL-3"
SLOT=0

DEPEND="sys-libs/ncurses:0="
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/no-more-secrets-9999-2018-10-25-respect-ldflags.patch )

src_compile() {
	CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" emake
}
