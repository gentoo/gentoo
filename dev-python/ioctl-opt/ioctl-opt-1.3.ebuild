# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} python3_13t )

inherit distutils-r1

MY_PN="python-${PN}"
DESCRIPTION="Linux's ioctl.h for Python"
HOMEPAGE="https://github.com/vpelletier/python-ioctl-opt"
SRC_URI="https://github.com/vpelletier/${MY_PN}/archive/refs/tags/${PV}.tar.gz -> ${MY_PN}-${PV}.gh.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

python_test() {
	"${EPYTHON}" ioctl_opt/__init__.py || die
}
