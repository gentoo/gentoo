# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4} )

inherit distutils-r1

DESCRIPTION="Python module for native access to the systemd facilities"
HOMEPAGE="https://github.com/systemd/python-systemd"
SRC_URI="https://github.com/systemd/python-systemd/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ppc ppc64 sparc x86"
IUSE=""

DEPEND="sys-apps/systemd"
RDEPEND="${DEPEND}
	!sys-apps/systemd[python(-)]"

src_compile() {
	emake systemd/id128-constants.h
	distutils-r1_src_compile
}
