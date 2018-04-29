# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson xdg

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://git.pwmt.org/pwmt/${PN}.git"
	EGIT_BRANCH="develop"
	inherit git-r3
else
	SRC_URI="https://pwmt.org/projects/${PN}/download/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
fi

DESCRIPTION="Comic book plug-in for zathura with 7zip, rar, tar and zip support"
HOMEPAGE="https://pwmt.org/projects/zathura/"

LICENSE="ZLIB"
SLOT="0"
IUSE=""

RDEPEND="
	>=app-text/zathura-0.2.0
	app-arch/libarchive
	dev-libs/girara
	x11-libs/cairo
"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_postinst() {
	xdg_pkg_postinst

	einfo "Consider installing app-arch/p7zip app-arch/tar app-arch/unrar
		app-arch/unzip for additional file support."
}
