# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyrtf/pyrtf-0.45-r1.ebuild,v 1.1 2015/02/18 06:23:11 idella4 Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

MY_PN="PyRTF"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A set of Python classes that make it possible to produce RTF documents from Python programs"
HOMEPAGE="http://pyrtf.sourceforge.net http://pypi.python.org/pypi/PyRTF"
SRC_URI="mirror://sourceforge/$PN/${MY_P}.tar.gz"

LICENSE="|| ( GPL-2 LGPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	python-single-r1_pkg_setup
}
