# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV=$(ver_rs 2 '-')
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Circular layout visualization of genomic and other data"
HOMEPAGE="http://mkweb.bcgsc.ca/circos/"
SRC_URI="http://mkweb.bcgsc.ca/circos/distribution/${PN}-${MY_PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/${MY_P}"

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
	dev-perl/List-MoreUtils
	dev-perl/Clone
	dev-perl/Cwd-Guard
	virtual/perl-File-Temp
	dev-perl/Font-TTF
	dev-perl/SVG
	dev-perl/Text-Format
	dev-perl/Statistics-Basic
	virtual/perl-Text-Balanced"
RDEPEND="${DEPEND}"

src_install() {
	insinto /opt/${PN}
	doins -r .

	exeinto /opt/${PN}/bin
	doexe bin/circos bin/gddiag

	dosym ../../opt/${PN}/bin/circos /usr/bin/circos

	einstalldocs
	local d
	while IFS="" read -d $'\0' -r d; do
		dodoc "${d}"
	done < <(find . -maxdepth 1 -type f -print0)
}
