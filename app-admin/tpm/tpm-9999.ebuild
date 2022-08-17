# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Tiny password manager"
HOMEPAGE="https://github.com/nmeum/tpm"
if [[ "${PV}" == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/nmeum/${PN}.git"
else
	SRC_URI="https://github.com/nmeum/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"

RDEPEND="app-crypt/gnupg"
BDEPEND="dev-lang/perl"

src_install() {
	emake install DESTDIR="${D}" PREFIX="${EPREFIX}/usr"
}
