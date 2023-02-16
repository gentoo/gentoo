# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

PARENT_PN="certbot"
PARENT_P="${PARENT_PN}-${PV}"

if [[ "${PV}" == *9999 ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/certbot/certbot.git"
	EGIT_SUBMODULES=()
	EGIT_CHECKOUT_DIR="${WORKDIR}/${PARENT_P}"
else
	SRC_URI="
		https://github.com/certbot/certbot/archive/v${PV}.tar.gz
			-> ${PARENT_P}.gh.tar.gz
	"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
fi

DESCRIPTION="An implementation of the ACME protocol"
HOMEPAGE="
	https://github.com/certbot/certbot
	https://letsencrypt.org/
"

LICENSE="Apache-2.0"
SLOT="0"

S="${WORKDIR}/${PARENT_P}/${PN}"

BDEPEND="
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	)
"

RDEPEND="
	dev-python/chardet[${PYTHON_USEDEP}]
	>=dev-python/cryptography-2.5.0[${PYTHON_USEDEP}]
	>=dev-python/josepy-1.13.0[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-17.5.0[${PYTHON_USEDEP}]
	dev-python/pyrfc3339[${PYTHON_USEDEP}]
	>=dev-python/pytz-2019.3[${PYTHON_USEDEP}]
	>=dev-python/requests-2.20.0[${PYTHON_USEDEP}]
	>=dev-python/requests-toolbelt-0.3.0[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs dev-python/sphinx-rtd-theme
distutils_enable_tests pytest
