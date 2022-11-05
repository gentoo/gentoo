# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

SRC_URI="https://github.com/certbot/certbot/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
KEYWORDS="~amd64 ~x86"
S="${WORKDIR}"/certbot-${PV}/${PN}

DESCRIPTION="DNSimple Authenticator plugin for Certbot (Let's Encrypt Client)"
HOMEPAGE="https://github.com/certbot/certbot https://letsencrypt.org/"

LICENSE="Apache-2.0"
SLOT="0"

RDEPEND="
	>=app-crypt/certbot-${PV}[${PYTHON_USEDEP}]
	>=app-crypt/acme-${PV}[${PYTHON_USEDEP}]
	dev-python/zope-interface[${PYTHON_USEDEP}]
	>=dev-python/dns-lexicon-3.2.1[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs dev-python/sphinx_rtd_theme
distutils_enable_tests pytest
