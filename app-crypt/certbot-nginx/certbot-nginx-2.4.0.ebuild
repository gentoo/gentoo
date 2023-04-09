# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

PARENT_PN="${PN%-nginx}"
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
	KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv x86"
fi

DESCRIPTION="Nginx plugin for Certbot (Let’s Encrypt client)"
HOMEPAGE="
	https://github.com/certbot/certbot
	https://letsencrypt.org/
"

LICENSE="Apache-2.0"
SLOT="0"

S="${WORKDIR}/${PARENT_P}/${PN}"

BDEPEND="
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"

RDEPEND="
	>=app-crypt/acme-${PV}[${PYTHON_USEDEP}]
	>=app-crypt/certbot-${PV}[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-17.5.0[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-2.2.1[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
