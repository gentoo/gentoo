# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=bdepend

inherit distutils-r1 python-utils-r1

EGIT_COMMIT="3480e70bb19eef22f4e1beeddd236f44414ac5ac"
DESCRIPTION="Use Cache URLs in your Django application"
HOMEPAGE="https://github.com/epicserve/django-cache-url"
SRC_URI="https://github.com/epicserve/django-cache-url/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
DOCS=( AUTHORS.rst CHANGELOG.rst README.rst )
distutils_enable_tests pytest
