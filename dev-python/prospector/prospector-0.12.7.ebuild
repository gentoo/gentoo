# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )
inherit distutils-r1

DESCRIPTION="Analyze Python code and output information about errors and potential problems"
HOMEPAGE="https://prospector.landscape.io"
SRC_URI="https://github.com/landscapeio/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-python/pylint-1.5.6
	>=dev-python/pylint-celery-0.3
	>=dev-python/pylint-django-0.7.2
	>=dev-python/pylint-flask-0.3
	>=dev-python/pylint-plugin-utils-0.2.6
	>=dev-python/pylint-common-0.2.5
	>=dev-python/requirements-detector-0.4.1
	>=dev-python/setoptconf-0.2.0
	>=dev-python/dodgy-0.1.9
	dev-python/pyyaml
	>=dev-python/mccabe-0.5.0
	>=dev-python/pyflakes-0.8.1
	=dev-python/pycodestyle-2.0.0
	>=dev-python/pep8-naming-0.5.0
	>=dev-python/pydocstyle-2.0.0
"
DEPEND="${RDEPEND}"
