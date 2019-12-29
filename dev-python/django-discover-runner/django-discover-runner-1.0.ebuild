# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python3_{5,6} )

inherit distutils-r1

DESCRIPTION="A Django test runner based on unittest2's test discovery"
HOMEPAGE="https://github.com/jezdez/django-discover-runner
	https://pypi.org/project/django-discover-runner/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/django[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
