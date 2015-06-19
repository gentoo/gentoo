# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-visualization/circos/circos-0.55.ebuild,v 1.3 2015/04/01 22:23:54 dilfridge Exp $

EAPI=4

DESCRIPTION="Circular layout visualization of genomic and other data"
HOMEPAGE="http://mkweb.bcgsc.ca/circos/"
SRC_URI="http://mkweb.bcgsc.ca/circos/distribution/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

DEPEND="dev-perl/Config-General
	dev-perl/GD
	dev-perl/Math-Bezier
	dev-perl/Math-Round
	dev-perl/Math-VecStat
	dev-perl/Params-Validate
	dev-perl/Readonly
	dev-perl/regexp-common
	>=dev-perl/Set-IntSpan-1.11
	dev-perl/Graphics-ColorObject
	dev-perl/List-MoreUtils"
RDEPEND="${DEPEND}"

src_install() {
	insinto /opt/${PN}
	find * -maxdepth 0 -type d | xargs doins -r
	exeinto /opt/${PN}/bin
	doexe bin/circos bin/gddiag
	dosym /opt/${PN}/bin/circos /usr/bin/circos
	find * -maxdepth 0 -type f | xargs dodoc
}
