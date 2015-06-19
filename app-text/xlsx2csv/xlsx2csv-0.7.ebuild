# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/xlsx2csv/xlsx2csv-0.7.ebuild,v 1.3 2015/04/08 07:30:33 mgorny Exp $

EAPI="5"
PYTHON_COMPAT=( python{2_7,3_3,3_4} )
PYTHON_REQ_USE="xml"

inherit distutils-r1

DESCRIPTION="Convert MS Office xlsx files to CSV"
HOMEPAGE="https://github.com/dilshod/xlsx2csv/"
SRC_URI="https://github.com/dilshod/${PN}/archive/release/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-lang/perl"

S=${WORKDIR}/${PN}-release-${PV}

python_compile_all() {
	emake -C man
}

python_install_all() {
	distutils-r1_python_install_all
	doman man/${PN}.1
}
