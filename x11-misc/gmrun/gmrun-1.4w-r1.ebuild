# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/WdesktopX/${PN}.git"
	EGIT_BRANCH="master"
else
	SRC_URI="https://github.com/wdlkmpx/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="amd64 ~mips ppc x86"
fi

DESCRIPTION="A GTK-2 based launcher box with bash style auto completion!"
HOMEPAGE="https://github.com/wdlkmpx/gmrun"

LICENSE="ISC"
SLOT="0"
IUSE="nls xdg"

RDEPEND="x11-libs/gtk+:3"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	econf \
		--disable-gtk2 \
		$(use_enable nls) \
		$(use_enable xdg)
}
