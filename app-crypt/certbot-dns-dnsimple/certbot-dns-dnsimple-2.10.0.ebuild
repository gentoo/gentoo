# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

MY_P=certbot-${PV}
DESCRIPTION="DNSimple Authenticator plugin for Certbot (Let's Encrypt Client)"
HOMEPAGE="
	https://github.com/certbot/certbot/
	https://pypi.org/project/certbot-dns-dnsimple/
	https://certbot-dns-dnsimple.readthedocs.io/en/stable/
"
# Use common certbot tarball
SRC_URI="
	https://github.com/certbot/certbot/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}/${PN}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=app-crypt/acme-${PV}[${PYTHON_USEDEP}]
	>=app-crypt/certbot-${PV}[${PYTHON_USEDEP}]
	>=dev-python/dns-lexicon-3.2.1[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs \
	dev-python/sphinx-rtd-theme
distutils_enable_tests pytest
