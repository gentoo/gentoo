# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/django-international/django-international-0.0.6.ebuild,v 1.5 2015/04/08 08:04:52 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="Country and currency data for Django projects"
HOMEPAGE="http://pypi.python.org/pypi/django-international https://bitbucket.org/monwara/django-international"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"

KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-python/django[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
