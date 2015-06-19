# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/jama/jama-1.2.5.ebuild,v 1.2 2012/08/03 19:28:50 bicatali Exp $

inherit versionator

MYP="${PN}$(replace_all_version_separators '')"
DOCPV=102

DESCRIPTION="Java-like matrix C++ templates"
HOMEPAGE="http://math.nist.gov/tnt/"
SRC_URI="http://math.nist.gov/tnt/${MYP}.zip
	doc? ( http://math.nist.gov/tnt/${PN}${DOCPV}doc.zip )"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

IUSE="doc"

DEPEND="app-arch/unzip"
RDEPEND="sci-libs/tnt"

S="${WORKDIR}"

src_install() {
	insinto /usr/include
	doins *.h || die
	use doc && dohtml doxygen/html/*
}
