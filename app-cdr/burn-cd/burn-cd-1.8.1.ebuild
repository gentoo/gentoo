# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit python-r1

DESCRIPTION="Smart console frontend for the cdrkit/cdrtools & dvd+rw-tools"
HOMEPAGE="https://github.com/aglyzov/burn-cd/"
SRC_URI="https://github.com/aglyzov/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	virtual/cdrtools
	app-cdr/dvd+rw-tools"

src_install() {
	newbin ${P} ${PN}
	insinto /etc
	newins dotburn-cd.conf burn-cd.conf
}
