# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9,10} )
inherit distutils-r1

MY_COMMIT="ba0e2eee8f50cc84706f816dbc57897319e2250c"

DESCRIPTION="This module implements the HMAC Key Derivation function"
HOMEPAGE="https://github.com/casebeer/python-hkdf"
SRC_URI="https://github.com/casebeer/${PN}/archive/${MY_COMMIT}.zip -> ${P}.zip"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-arch/unzip"

S="${WORKDIR}/${PN}-${MY_COMMIT}"

distutils_enable_tests setup.py
