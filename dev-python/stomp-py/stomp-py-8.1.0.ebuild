# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

MY_PN="${PN//-/.}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python client library for the STOMP messaging protocol"
HOMEPAGE="https://pypi.org/project/stomp.py/ https://github.com/jasonrbriggs/stomp.py/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="<dev-python/docopt-0.7.0[${PYTHON_USEDEP}]"

S="${WORKDIR}"/${MY_P}

# stomp.py test suite requires quite a few appropriately configured
# messaging servers (as of 7.0.0: RabbitMQ, ActiveMQ, ActiveMQ Artemis,
# stompserver). Upstream relies on Docker to provide those servers, however
# doing the same in src_test would require both granting the portage user
# extra permissions and packaging the base image (trying to download it
# on the fly would violate the network sandbox).
# Side note: PyPI tarballs do not include tests.
RESTRICT="test"
