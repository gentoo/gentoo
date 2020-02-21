# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )
inherit python-any-r1

DESCRIPTION="An ambiguously named music replacement set for OpenTTD"
HOMEPAGE="http://bundles.openttdcoop.org/openmsx/"
SRC_URI="http://bundles.openttdcoop.org/openmsx/releases/${PV}/${P}-source.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc64 ~x86"
IUSE=""

DEPEND="${PYTHON_DEPS}"

S=${WORKDIR}/${P}-source

pkg_setup() {
	python-any-r1_pkg_setup
}

src_compile() {
	emake _V= bundle
}

src_install() {
	insinto "/usr/share/games/openttd/gm/${P}"
	doins ${P}/{*.mid,openmsx.obm}
	dodoc ${P}/{changelog.txt,readme.txt}
}
