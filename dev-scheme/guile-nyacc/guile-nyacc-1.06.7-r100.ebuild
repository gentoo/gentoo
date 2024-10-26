# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GUILE_COMPAT=( 2-2 3-0 )
inherit guile

DESCRIPTION="Guile modules for generating parsers and lexical analyzers"
HOMEPAGE="http://www.nongnu.org/nyacc/"
SRC_URI="mirror://nongnu/nyacc/nyacc-${PV}.tar.gz"
S="${WORKDIR}/nyacc-${PV}"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	${GUILE_DEPS}
	>=dev-scheme/bytestructures-2.0.2-r100[${GUILE_USEDEP}]
"
DEPEND="${RDEPEND}"

src_install() {
	guile_src_install

	# Fix docs location
	mv "${ED}"/usr/share/doc/nyacc "${ED}"/usr/share/doc/${PF} || die
}
