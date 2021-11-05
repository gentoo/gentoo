# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Additional skins for XXV"
HOMEPAGE="https://projects.vdr-developer.org/projects/xxv"
SRC_URI="mirror://vdr-developerorg/719/${P}.tgz
		mirror://vdr-developerorg/720/xxv-jason-${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="~www-misc/xxv-${PV}"

src_install() {
	insinto /usr/share/xxv/skins
	doins -r . "${WORKDIR}"/jason/.
}
