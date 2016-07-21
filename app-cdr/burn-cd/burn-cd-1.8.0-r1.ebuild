# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="Smart console frontend for virtual/cdrtools and dvd+rw-tools"
HOMEPAGE="http://burn-cd.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="${PYTHON_DEPS}
	virtual/cdrtools
	app-cdr/dvd+rw-tools"
DEPEND=""

REQUIRED_USE=${PYTHON_REQUIRED_USE}

S=${WORKDIR}

src_install() {
	python_fix_shebang ${P}
	newbin ${P} ${PN}
}
