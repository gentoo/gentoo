# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="WebDAV filesystem with special features for accessing subversion repositories"
HOMEPAGE="http://noedler.de/projekte/wdfs/"
SRC_URI="http://noedler.de/projekte/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 x86"

RDEPEND="
	dev-libs/glib:2
	>=net-libs/neon-0.24.7:=
	>=sys-fs/fuse-2.5:0
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-fix-Waddress.patch"
)
