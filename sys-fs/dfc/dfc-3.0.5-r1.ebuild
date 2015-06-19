# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/dfc/dfc-3.0.5-r1.ebuild,v 1.1 2015/05/08 07:22:40 dlan Exp $

EAPI=5
inherit cmake-utils

DESCRIPTION="A simple CLI tool that display file system usage, with colors"
HOMEPAGE="http://projects.gw-computing.net/projects/dfc"
SRC_URI="http://projects.gw-computing.net/attachments/download/467/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="nls"

DEPEND="nls? (
	virtual/libintl
	sys-devel/gettext
)"
RDEPEND="nls? ( virtual/libintl )"

src_configure() {
	mycmakeargs=(
		# avoid installing xdg config in /usr
		-DXDG_CONFIG_DIR="${EPREFIX}"/etc/xdg
		# use the standard Gentoo doc path
		-DDFC_DOC_PATH="${EPREFIX}"/usr/share/doc/${PF}
		# disable automagic dependency
		$(cmake-utils_use nls NLS_ENABLED)
		-DLFS_ENABLED=ON
		-DGRIM=OFF
	)

	cmake-utils_src_configure
}
