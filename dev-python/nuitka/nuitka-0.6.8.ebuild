# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS="rdepend"

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1 optfeature

DESCRIPTION="Python to native compiler"
HOMEPAGE="https://www.nuitka.net"
SRC_URI="https://nuitka.net/releases/${P^}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="dev-util/scons[${PYTHON_USEDEP}]"

RDEPEND="${BDEPEND}
	dev-python/appdirs[${PYTHON_USEDEP}]"

DOCS=( Changelog.pdf Developer_Manual.pdf README.pdf )
S="${WORKDIR}/${P^}"

python_install() {
	distutils-r1_python_install
	python_optimize
	doman doc/nuitka.1 doc/nuitka3.1 doc/nuitka3-run.1 doc/nuitka-run.1
}

pkg_postinst() {
	optfeature "support for stand-alone executables" app-admin/chrpath
}
