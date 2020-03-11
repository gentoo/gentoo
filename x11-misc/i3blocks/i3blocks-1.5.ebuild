# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools bash-completion-r1

if [[ ${PV} = 9999 ]]; then
	inherit git-r3
fi

DESCRIPTION="highly flexible status line for the i3 window manager"
HOMEPAGE="https://github.com/vivien/i3blocks"
if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="https://github.com/vivien/${PN}"
else
	SRC_URI="https://github.com/vivien/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

SLOT="0"
LICENSE="GPL-3"

PATCHES=( "${FILESDIR}"/${PN}-disable-bash-completion.patch )

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	newbashcomp bash-completion ${PN}
}
