# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

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

DESCRIPTION="Nginx plugin for Certbot (Let’s Encrypt client)"
HOMEPAGE="
	https://github.com/certbot/certbot
	https://pypi.org/project/certbot-nginx/
	https://letsencrypt.org/
"

S="${WORKDIR}/${PARENT_P}/${PN}"
LICENSE="Apache-2.0"
SLOT="0"

# See certbot/setup.py for acme >= dep
RDEPEND="
	>=app-crypt/acme-${PV}[${PYTHON_USEDEP}]
	>=app-crypt/certbot-${PV}[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-25.0.0[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-2.4.7[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
