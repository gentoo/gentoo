# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
inherit distutils-r1

DESCRIPTION="Client for Slack supporting the Slack Web and Real Time Messaging API"
HOMEPAGE="https://github.com/slackapi/python-slackclient"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test" # upstream does not include tests in the package tarball!

RDEPEND="
	>dev-python/aiohttp-3.5.2[${PYTHON_USEDEP}]
	>dev-python/aiodns-1.0.0[${PYTHON_USEDEP}]
	"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	${RDEPEND}"
