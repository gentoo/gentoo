# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="MTKBabel is a Perl program to operate the i-Blue 747 GPS data logger"
HOMEPAGE="https://sourceforge.net/projects/mtkbabel/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
S="${WORKDIR}/${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-perl/Device-SerialPort
	dev-perl/TimeDate
"

src_install() {
	doman mtkbabel.1
	dobin mtkbabel
	dodoc MtkExtensionsv1.xsd README changelog
}
