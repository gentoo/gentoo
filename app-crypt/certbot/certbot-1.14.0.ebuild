# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=(python{3_7,3_8,3_9})
DISTUTILS_USE_SETUPTOOLS=rdepend

if [[ ${PV} == 9999* ]]; then
	EGIT_REPO_URI="https://github.com/certbot/certbot.git"
	inherit git-r3
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86"
fi
S=${WORKDIR}/${P}/${PN}

inherit distutils-r1

DESCRIPTION="Let's encrypt client to automate deployment of X.509 certificates"
HOMEPAGE="https://github.com/certbot/certbot https://letsencrypt.org/"

LICENSE="Apache-2.0"
SLOT="0"

RDEPEND="
	>=app-crypt/acme-1.8.0[${PYTHON_USEDEP}]
	>=dev-python/configargparse-0.9.3[${PYTHON_USEDEP}]
	>=dev-python/configobj-5.0.6[${PYTHON_USEDEP}]
	>=dev-python/cryptography-2.8[${PYTHON_USEDEP}]
	>=dev-python/distro-1.0.1[${PYTHON_USEDEP}]
	>=dev-python/josepy-1.1.0[${PYTHON_USEDEP}]
	>=dev-python/parsedatetime-2.4[${PYTHON_USEDEP}]
	dev-python/pyrfc3339[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/zope-component[${PYTHON_USEDEP}]
	dev-python/zope-interface[${PYTHON_USEDEP}]"
