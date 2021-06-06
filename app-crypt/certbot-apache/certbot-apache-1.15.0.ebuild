# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=(python{3_7,3_8,3_9})
DISTUTILS_USE_SETUPTOOLS=rdepend

if [[ ${PV} == 9999* ]]; then
	EGIT_REPO_URI="https://github.com/certbot/certbot.git"
	inherit git-r3
	S=${WORKDIR}/${P}/${PN}
else
	SRC_URI="https://github.com/${PN%-apache}/${PN%-apache}/archive/v${PV}.tar.gz -> ${PN%-apache}-${PV}.tar.gz"
	KEYWORDS="amd64 ~arm64 x86"
	S=${WORKDIR}/${PN%-apache}-${PV}/${PN}
fi

inherit distutils-r1

DESCRIPTION="Apache plugin for certbot (Let's Encrypt Client)"
HOMEPAGE="https://github.com/certbot/certbot https://letsencrypt.org/"

LICENSE="Apache-2.0"
SLOT="0"

RDEPEND=">=app-crypt/acme-0.29.0[${PYTHON_USEDEP}]
	>=app-crypt/certbot-1.6.0[${PYTHON_USEDEP}]
	dev-python/python-augeas[${PYTHON_USEDEP}]
	dev-python/zope-component[${PYTHON_USEDEP}]
	dev-python/zope-interface[${PYTHON_USEDEP}]"
