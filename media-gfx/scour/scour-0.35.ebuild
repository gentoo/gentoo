# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=(python{2_7,3_3,3_4,3_5})
inherit distutils-r1

DESCRIPTION="Take an SVG file and produce a cleaner and more concise file"
HOMEPAGE="http://www.codedread.com/scour/"
SRC_URI="https://github.com/codedread/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~x86"
IUSE=""

DEPEND="dev-python/six"
