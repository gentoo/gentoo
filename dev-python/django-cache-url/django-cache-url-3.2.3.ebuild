# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

EGIT_COMMIT="3480e70bb19eef22f4e1beeddd236f44414ac5ac"
DESCRIPTION="Use Cache URLs in your Django application"
HOMEPAGE="https://github.com/epicserve/django-cache-url"
SRC_URI="https://github.com/epicserve/django-cache-url/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( AUTHORS.rst CHANGELOG.rst README.rst )

distutils_enable_tests pytest

python_prepare_all() {
	sed -e '/--cov/d' -i setup.cfg || die
	distutils-r1_python_prepare_all
}
