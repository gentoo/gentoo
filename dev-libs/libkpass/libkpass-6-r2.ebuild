# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Libkpass is a C implementation to access KeePass 1.x format password databases"
HOMEPAGE="https://sourceforge.net/projects/libkpass/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="static-libs"

RDEPEND=">=dev-libs/nettle-2.7.1:="
DEPEND="${RDEPEND}"

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default

	use static-libs || rm -f "${ED}"/usr/lib*/${PN}.la
}
