# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_NAME=Autodia
DIST_VERSION=2.14
DIST_AUTHOR=TEEJAY
inherit perl-module

DESCRIPTION="Parses source code, XML or data and produces an XML document in Dia format"
HOMEPAGE="http://www.aarontrevena.co.uk/opensource/autodia/ ${HOMEPAGE}"
SRC_URI+=" mirror://gentoo/${DIST_NAME}-2.14-dbi.patch.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="graphviz test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/Template-Toolkit
	dev-perl/XML-Simple
	graphviz? (
		dev-perl/GraphViz
	)
"
BDEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Pod
	)
"

PATCHES=( "${WORKDIR}"/${DIST_NAME}-2.14-dbi.patch )

mydoc="DEVELOP"
