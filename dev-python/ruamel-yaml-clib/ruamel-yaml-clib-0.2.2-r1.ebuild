# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{7..10} )

inherit distutils-r1

MY_PN="${PN//-/.}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="C-based reader/scanner and emitter for dev-python/ruamel-yaml"
HOMEPAGE="https://pypi.org/project/ruamel.yaml.clib/ https://sourceforge.net/p/ruamel-yaml-clib/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ppc ppc64 sparc x86"

PATCHES=(
	 "${FILESDIR}"/${PN}-0.2.2-python3_10.patch
)

S="${WORKDIR}"/${MY_P}

python_install() {
	distutils-r1_python_install --single-version-externally-managed
}
