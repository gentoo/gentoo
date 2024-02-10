# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )
export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

inherit distutils-r1

DESCRIPTION="This project provides first-class OAuth library support for aiohttp"
HOMEPAGE="https://git.sr.ht/~whynothugo/aiohttp-oauthlib"
SRC_URI="https://git.sr.ht/~whynothugo/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="ISC"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"

RDEPEND="
	dev-python/aiohttp[${PYTHON_USEDEP}]
	>=dev-python/oauthlib-3.0.0[${PYTHON_USEDEP}]"

BDEPEND="dev-python/setuptools-scm[${PYTHON_USEDEP}]"

S="${WORKDIR}/${PN}-v${PV}"
