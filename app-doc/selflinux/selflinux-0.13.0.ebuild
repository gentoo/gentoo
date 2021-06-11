# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MY_P="SelfLinux-${PV}"

DESCRIPTION="german-language hypertext tutorial about Linux"
HOMEPAGE="http://selflinux.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}-html.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="FDL-1.1+"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

src_install() {
	dohtml * -r
}
