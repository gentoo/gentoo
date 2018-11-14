# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MY_P="SelfLinux-${PV}"

DESCRIPTION="german-language hypertext tutorial about Linux"
HOMEPAGE="http://selflinux.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}-html.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

S="${WORKDIR}/${MY_P}"

src_install() {
	dohtml * -r
}
