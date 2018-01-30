# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="Unicode Common Locale Data Repository"
HOMEPAGE="http://cldr.unicode.org/"
SRC_URI="http://${PN%-*}.org/Public/${PN/*-}/${PV}/core.zip -> ${PN}-common-${PV}.zip"

LICENSE="unicode"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ia64 ppc ppc64 ~sparc x86"
IUSE=""

DEPEND="app-arch/unzip"
S="${WORKDIR}"

src_install() {
	insinto /usr/share/${PN/-//}
	doins -r common
}
