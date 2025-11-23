# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/keis/git-fixup"
	inherit git-r3
else
	SRC_URI="https://github.com/keis/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Fighting the copy-paste element of your rebase workflow"
HOMEPAGE="https://github.com/keis/git-fixup"

LICENSE="ISC"
SLOT="0"

RDEPEND="!<app-portage/mgorny-dev-scripts-53"

src_compile() { :; }

src_install() {
	emake install{,-fish,-zsh} DESTDIR="${ED}" PREFIX="${EPREFIX}/usr"
}
