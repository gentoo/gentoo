# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/django-select2/django-select2-3.2.1.ebuild,v 1.2 2013/04/02 16:28:26 prometheanfire Exp $

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="Django-Select2"

DESCRIPTION="A Django integration of Select2"
HOMEPAGE="https://pypi.python.org/pypi/Django-Select2"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"

S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/django[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
