# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${P}_linux"

DESCRIPTION="Robust automatic backbone assignment of proteins"
HOMEPAGE="http://www.mpibpc.mpg.de/groups/zweckstetter/_links/software_mars.htm"
SRC_URI="http://www.mpibpc.mpg.de/groups/zweckstetter/_software_files/_${PN}/${MY_P}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples"
RESTRICT=mirror

RDEPEND="sci-biology/psipred"

S="${WORKDIR}/${MY_P}"

QA_PREBUILT="opt/mars/*"

src_install() {
	dobin bin/runmars*

	exeinto /opt/${PN}/
	doexe bin/{${PN},calcJC-S2,runmars*,*.awk} *.awk

	insinto /opt/${PN}/
	doins bin/*.{tab,txt}

	if use examples; then
		insinto /usr/share/${PN}/
		doins -r examples
	fi

	cat >> "${T}"/23mars <<- EOF || die
		MARSHOME="${EPREFIX}/opt/${PN}"
	EOF

	doenvd "${T}"/23mars
}
