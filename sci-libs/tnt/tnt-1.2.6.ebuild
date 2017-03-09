# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit versionator

MYP="${PN}$(replace_all_version_separators '')"
DOCPV=120

DESCRIPTION="Template Numerical Toolkit: C++ headers for array and matrices"
HOMEPAGE="http://math.nist.gov/tnt/"
SRC_URI="http://math.nist.gov/tnt/${MYP}.zip
	doc? ( http://math.nist.gov/tnt/${PN}${DOCPV}doc.zip )"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

IUSE="doc"

DEPEND="app-arch/unzip"
RDEPEND=""

S="${WORKDIR}"

src_install() {
	insinto /usr/include
	doins *.h
	use doc && dohtml html/*
}
