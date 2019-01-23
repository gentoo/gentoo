# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.pwmt.org/pwmt/zathura-ps.git"
	EGIT_BRANCH="develop"
else
	KEYWORDS="amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
	SRC_URI="https://pwmt.org/projects/zathura/plugins/download/${P}.tar.xz"
fi

DESCRIPTION="PostScript plug-in for zathura"
HOMEPAGE="https://pwmt.org/projects/zathura-ps/download/"

LICENSE="ZLIB"
SLOT="0"

DEPEND="app-text/libspectre
	>=app-text/zathura-0.3.9
	dev-libs/girara
	dev-libs/glib:2
	x11-libs/cairo"

RDEPEND="${DEPEND}"

BDEPEND="virtual/pkgconfig"
