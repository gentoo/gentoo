# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Python interface to the Redmine REST API"
HOMEPAGE="https://github.com/maxtepkeev/python-redmine"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/requests[${PYTHON_USEDEP}]"

distutils_enable_tests nose

python_prepare_all() {
	# Remove the bundled copy of dev-python/requests...
	rm -r redminelib/packages/requests \
		|| die 'failed to remove the bundled copy of dev-python/requests'

	# and replace its local import statement with a global one.
	sed -i redminelib/packages/__init__.py \
		-e 's/from . import requests/import requests/' \
		|| die 'failed to replace the dev-python/requests library import'

	distutils-r1_python_prepare_all
}
