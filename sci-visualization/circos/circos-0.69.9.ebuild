# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN}-$(ver_rs 2 -)"
DESCRIPTION="Circular layout visualization of genomic and other data"
HOMEPAGE="http://circos.ca/"
SRC_URI="http://circos.ca/distribution/${MY_PN}.tgz"
S="${WORKDIR}/${MY_PN}"

LICENSE="GPL-2+ GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-perl/Config-General
	dev-perl/Font-TTF
	dev-perl/GD
	dev-perl/Math-Bezier
	dev-perl/Math-Round
	dev-perl/Math-VecStat
	dev-perl/Params-Validate
	dev-perl/Readonly
	dev-perl/Regexp-Common
	dev-perl/Set-IntSpan
	dev-perl/Statistics-Basic
	dev-perl/SVG
	dev-perl/Text-Format
	dev-perl/Graphics-ColorObject
	dev-perl/List-MoreUtils"
RDEPEND="${DEPEND}"

src_prepare() {
	# remove windows only things
	rm -r "${S}/bin/${PN}.exe" || die
	rm -r "${S}/bin/compile.bat" || die
	default
}

src_install() {
	insinto /opt/${PN}
	doins -r */

	exeinto /opt/${PN}/bin
	doexe bin/circos bin/gddiag

	dosym ../../opt/${PN}/bin/circos /usr/bin/circos

	einstalldocs

	local d
	while IFS="" read -d $'\0' -r d; do
		dodoc "${d}"
	done < <(find * -maxdepth 0 -type f -print0)
}
