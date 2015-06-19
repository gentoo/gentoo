# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/burn-cd/burn-cd-1.8.0-r1.ebuild,v 1.1 2014/12/26 19:51:34 mgorny Exp $

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
