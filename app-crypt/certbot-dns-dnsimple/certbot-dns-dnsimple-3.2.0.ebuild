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
	# Only for amd64 and x86 because of dev-python/dns-lexicon
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="DNSimple Authenticator plugin for Certbot (Let’s Encrypt Client)"
HOMEPAGE="
	https://github.com/certbot/certbot
	https://pypi.org/project/certbot-dns-dnsimple/
	https://certbot-dns-dnsimple.readthedocs.io/en/stable/
	https://letsencrypt.org/
"

S="${WORKDIR}/${PARENT_P}/${PN}"
LICENSE="Apache-2.0"
SLOT="0"

# See certbot/setup.py for acme >= dep
RDEPEND="
	>=app-crypt/acme-${PV}[${PYTHON_USEDEP}]
	>=app-crypt/certbot-${PV}[${PYTHON_USEDEP}]
	>=dev-python/dns-lexicon-3.14.1[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs \
	dev-python/sphinx-rtd-theme
distutils_enable_tests pytest
