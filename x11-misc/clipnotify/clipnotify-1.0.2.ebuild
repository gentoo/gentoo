# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Notify on new X clipboard events"
HOMEPAGE="https://github.com/cdown/clipnotify"
SRC_URI="https://github.com/cdown/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	x11-libs/libX11
	x11-libs/libXfixes
"
RDEPEND="${DEPEND}"

src_install() {
	dobin clipnotify
}
