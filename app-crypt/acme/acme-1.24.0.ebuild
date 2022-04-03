# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

if [[ ${PV} == 9999* ]]; then
	EGIT_REPO_URI="https://github.com/certbot/certbot.git"
	inherit git-r3
	S=${WORKDIR}/${P}/${PN}
else
	SRC_URI="https://github.com/certbot/certbot/archive/v${PV}.tar.gz -> certbot-${PV}.tar.gz"
	KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv x86"
	S=${WORKDIR}/certbot-${PV}/acme
fi

DESCRIPTION="An implementation of the ACME protocol"
HOMEPAGE="https://github.com/certbot/certbot https://letsencrypt.org/"

LICENSE="Apache-2.0"
SLOT="0"

RDEPEND="
	dev-python/chardet[${PYTHON_USEDEP}]
	>=dev-python/cryptography-2.5.0[${PYTHON_USEDEP}]
	>=dev-python/josepy-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-17.3.0[${PYTHON_USEDEP}]
	dev-python/pyrfc3339[${PYTHON_USEDEP}]
	>=dev-python/pytz-2019.3[${PYTHON_USEDEP}]
	>=dev-python/requests-2.20.0[${PYTHON_USEDEP}]
	>=dev-python/requests-toolbelt-0.3.0[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs dev-python/sphinx_rtd_theme
distutils_enable_tests pytest
