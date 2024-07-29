# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

if [[ "${PV}" == *9999 ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/certbot/certbot.git"
	EGIT_SUBMODULES=()
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
else
	SRC_URI="
		https://github.com/certbot/certbot/archive/v${PV}.tar.gz
			-> ${P}.gh.tar.gz
	"
	KEYWORDS="amd64 arm arm64 ~ppc64 ~riscv x86"
fi

DESCRIPTION="Let’s Encrypt client to automate deployment of X.509 certificates"
HOMEPAGE="
	https://github.com/certbot/certbot/
	https://pypi.org/project/certbot/
	https://letsencrypt.org/
"

S="${WORKDIR}/${P}/${PN}"
LICENSE="Apache-2.0"
SLOT="0"

IUSE="selinux"

BDEPEND="
	test? (
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	)
"

# See certbot/setup.py for acme >= dep
RDEPEND="
	>=app-crypt/acme-${PV}[${PYTHON_USEDEP}]
	>=dev-python/ConfigArgParse-1.5.3[${PYTHON_USEDEP}]
	>=dev-python/configobj-5.0.6[${PYTHON_USEDEP}]
	>=dev-python/cryptography-3.2.1[${PYTHON_USEDEP}]
	>=dev-python/distro-1.0.1[${PYTHON_USEDEP}]
	>=dev-python/josepy-1.13.0[${PYTHON_USEDEP}]
	>=dev-python/parsedatetime-2.4[${PYTHON_USEDEP}]
	dev-python/pyrfc3339[${PYTHON_USEDEP}]
	>=dev-python/pytz-2019.3[${PYTHON_USEDEP}]
	selinux? ( sec-policy/selinux-certbot )
"

distutils_enable_sphinx docs \
	dev-python/sphinx-rtd-theme
distutils_enable_tests pytest

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
