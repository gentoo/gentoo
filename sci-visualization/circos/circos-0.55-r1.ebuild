# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

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
	dev-perl/Regexp-Common
	>=dev-perl/Set-IntSpan-1.11
	dev-perl/Graphics-ColorObject
	dev-perl/List-MoreUtils"
RDEPEND="${DEPEND}"

src_install() {
	insinto /opt/${PN}
	doins -r */

	exeinto /opt/${PN}/bin
	doexe bin/circos bin/gddiag

	dosym /opt/${PN}/bin/circos /usr/bin/circos

	einstalldocs
	local d
	while IFS="" read -d $'\0' -r d; do
		dodoc "${d}"
	done < <(find * -maxdepth 0 -type f -print0)
}
