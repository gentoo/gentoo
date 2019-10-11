# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit freebsd

DESCRIPTION="Manage locks from shell scripts"
HOMEPAGE="http://svnweb.freebsd.org/ports/head/sysutils/flock/"
SRC_URI="http://www.zonov.org/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=""
DEPEND="sys-freebsd/freebsd-mk-defs
	virtual/pmake"
