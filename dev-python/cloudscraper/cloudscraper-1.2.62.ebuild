# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1 optfeature

DESCRIPTION="A Python module to bypass Cloudflare's anti-bot page"
HOMEPAGE="https://github.com/VeNoMouS/cloudscraper"
SRC_URI="https://github.com/VeNoMouS/${PN}/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"

RDEPEND="
	dev-python/pyparsing[${PYTHON_USEDEP}]
	dev-python/requests-toolbelt[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/js2py[${PYTHON_USEDEP}]
		dev-python/pytest-forked[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
		dev-python/responses[${PYTHON_USEDEP}]
		net-libs/nodejs
	)
"

distutils_enable_tests pytest

pkg_postinst() {
	optfeature "brotli decompresssion support" "dev-python/brotlipy"

	optfeature "js2py interpreter support" "dev-python/js2py"
	optfeature "node.js interpreter support" "net-libs/nodejs"
}
