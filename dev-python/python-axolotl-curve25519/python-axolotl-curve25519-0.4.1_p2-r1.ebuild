# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7,8} )

inherit distutils-r1

MY_PV="${PV/_p/-}"

DESCRIPTION="A python wrapper for the curve25519 library with ed25519 signatures"
HOMEPAGE="https://github.com/tgalal/python-axolotl-curve25519"
SRC_URI="https://github.com/tgalal/${PN}/archive/${MY_PV}.tar.gz -> ${PN}-${MY_PV}.tar.gz"

LICENSE="BSD GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${PN}-${MY_PV}"
