# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-r1

DESCRIPTION="Cli interface for dropbox daemon (python)"
HOMEPAGE="http://www.dropbox.com/"
SRC_URI="https://dev.gentoo.org/~hasufell/distfiles/${P}.py.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="net-misc/dropbox
	${PYTHON_DEPS}"

S=${WORKDIR}

src_install() {
	newbin ${P}.py ${PN}
	python_replicate_script "${D}"/usr/bin/${PN}
}
