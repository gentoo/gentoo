# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Java-like matrix C++ templates"
HOMEPAGE="https://math.nist.gov/tnt/"
SRC_URI="https://math.nist.gov/tnt/${PN}${PV//./}.zip
	doc? ( https://math.nist.gov/tnt/${PN}102doc.zip )"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="sci-libs/tnt"
BDEPEND="app-arch/unzip"

src_install() {
	doheader *.h

	use doc && HTML_DOCS=( doxygen/html/. )
	einstalldocs
}
