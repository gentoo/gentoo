# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

MY_PV="${PV/_p/-}"

DESCRIPTION="A python wrapper for the curve25519 library with ed25519 signatures"
HOMEPAGE="https://github.com/tgalal/python-axolotl-curve25519"
SRC_URI="https://github.com/tgalal/${PN}/archive/${MY_PV}.tar.gz -> ${PN}-${MY_PV}.gh.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="BSD GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~riscv x86"
