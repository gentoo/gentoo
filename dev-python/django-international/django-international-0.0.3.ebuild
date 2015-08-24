# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="Country and currency data for Django projects"
HOMEPAGE="https://pypi.python.org/pypi/django-international https://bitbucket.org/monwara/django-international"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/django"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

src_install() {
	distutils-r1_python_install_all
	dodir usr/share/doc/${P}/fixtures
	docompress -x usr/share/doc/${P}/fixtures
	insinto usr/share/doc/${P}/fixtures
	doins international/fixtures/countries_fixture.json
}
