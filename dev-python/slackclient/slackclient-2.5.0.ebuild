# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="Client for Slack supporting the Slack Web and Real Time Messaging API"
HOMEPAGE="https://github.com/slackapi/python-slackclient"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test" # upstream does not include tests in the package tarball!

RDEPEND="
	dev-python/aiodns[${PYTHON_USEDEP}]
	dev-python/aiohttp[${PYTHON_USEDEP}]"

src_prepare() {
	# Upstream uses pytest-runner as an extra optional target in setup.py as
	# part of tooling to generate distfiles.
	sed -i \
		-e '/setup_requires=/s,"pytest-runner",,' \
		"${S}"/setup.py || die
	default
}
