# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS="bdepend"
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

MY_PV="${PV/_p/-}"

DESCRIPTION="A python wrapper for the curve25519 library with ed25519 signatures"
HOMEPAGE="https://github.com/tgalal/python-axolotl-curve25519"
SRC_URI="https://github.com/tgalal/${PN}/archive/${MY_PV}.tar.gz -> ${PN}-${MY_PV}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="BSD GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
