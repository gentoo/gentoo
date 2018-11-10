# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A Python package for implementing SCGI servers"
HOMEPAGE="https://pypi.org/project/scgi/ http://python.ca/scgi/ http://www.mems-exchange.org/software/scgi/"
SRC_URI="http://python.ca/scgi/releases/${P}.tar.gz"

LICENSE="CNRI"
SLOT="0"
KEYWORDS="amd64 hppa ~ppc x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

DEPEND=""
RDEPEND=""

pkg_postinst() {
	elog "This package does not install mod_scgi!"
	elog "Please install www-apache/mod_scgi if you need it."
}
