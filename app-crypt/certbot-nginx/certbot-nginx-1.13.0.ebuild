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
	SRC_URI="https://github.com/${PN%-nginx}/${PN%-nginx}/archive/v${PV}.tar.gz -> ${PN%-nginx}-${PV}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	S=${WORKDIR}/${PN%-nginx}-${PV}/${PN}
fi

inherit distutils-r1

DESCRIPTION="Nginx plugin for certbot (Let's Encrypt Client)"
HOMEPAGE="https://github.com/certbot/certbot https://letsencrypt.org/"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RDEPEND="
	>=app-crypt/acme-1.4.0[${PYTHON_USEDEP}]
	>=app-crypt/certbot-1.6.0[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-17.3.0[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-2.2.0[${PYTHON_USEDEP}]
	dev-python/zope-interface[${PYTHON_USEDEP}]"
