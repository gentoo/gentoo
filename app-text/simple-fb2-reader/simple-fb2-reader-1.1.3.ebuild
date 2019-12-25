# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake-utils xdg
DESCRIPTION="A simple gtk3 reader for fb2 ebooks"
HOMEPAGE="https://github.com/Cactus64k/simple-fb2-reader"
SRC_URI="https://github.com/Cactus64k/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RDEPEND="x11-libs/gtk+:3
	dev-libs/libxml2
	dev-libs/libzip
	dev-db/sqlite"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig"

src_prepare() {
	xdg_src_prepare
	cmake-utils_src_prepare
}
