# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit out-of-source

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://bitbucket.org/gentoo/${PN}.git"
	inherit autotools git-r3
else
	SRC_URI="https://www.bitbucket.org/gentoo/${PN}/downloads/${P}.tar.bz2"
	KEYWORDS="~amd64 ~riscv ~x86"
fi

DESCRIPTION="A repository commit helper"
HOMEPAGE="https://bitbucket.org/gentoo/repo-commit/"

LICENSE="BSD"
SLOT="0"

RDEPEND="sys-apps/portage"

src_prepare() {
	default
	[[ ${PV} == *9999 ]] && eautoreconf
}
