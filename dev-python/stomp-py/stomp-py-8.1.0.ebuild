# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYPI_NO_NORMALIZE=1
PYPI_PN=${PN/-/.}
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Python client library for the STOMP messaging protocol"
HOMEPAGE="https://pypi.org/project/stomp.py/ https://github.com/jasonrbriggs/stomp.py/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="<dev-python/docopt-0.7.0[${PYTHON_USEDEP}]"

# stomp.py test suite requires quite a few appropriately configured
# messaging servers (as of 7.0.0: RabbitMQ, ActiveMQ, ActiveMQ Artemis,
# stompserver). Upstream relies on Docker to provide those servers, however
# doing the same in src_test would require both granting the portage user
# extra permissions and packaging the base image (trying to download it
# on the fly would violate the network sandbox).
# Side note: PyPI tarballs do not include tests.
RESTRICT="test"
