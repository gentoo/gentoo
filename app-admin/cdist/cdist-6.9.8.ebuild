# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )

DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1

DESCRIPTION="A usable configuration management system"
HOMEPAGE="https://www.cdi.st/ https://code.ungleich.ch/ungleich-public/cdist"
SRC_URI="https://code.ungleich.ch/ungleich-public/cdist/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=( "${FILESDIR}"/test.patch )

distutils_enable_sphinx docs/src dev-python/sphinx-rtd-theme
distutils_enable_tests unittest

python_prepare_all() {
	echo "VERSION='${PV}'" > cdist/version.py || die "Failed to set version"
	distutils-r1_python_prepare_all
}
