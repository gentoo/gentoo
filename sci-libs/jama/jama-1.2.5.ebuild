# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit versionator

MYP="${PN}$(replace_all_version_separators '')"
DOCPV=102

DESCRIPTION="Java-like matrix C++ templates"
HOMEPAGE="https://math.nist.gov/tnt/"
SRC_URI="https://math.nist.gov/tnt/${MYP}.zip
	doc? ( https://math.nist.gov/tnt/${PN}${DOCPV}doc.zip )"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc"

DEPEND="app-arch/unzip"
RDEPEND="sci-libs/tnt"

S="${WORKDIR}"

src_install() {
	doheader *.h

	use doc && HTML_DOCS=( doxygen/html/. )
	einstalldocs
}
