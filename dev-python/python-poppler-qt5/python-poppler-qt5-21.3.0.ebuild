# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=sip
PYTHON_COMPAT=( python3_{9..10} )

inherit distutils-r1 multiprocessing qmake-utils

DESCRIPTION="Python binding for libpoppler-qt5"
HOMEPAGE="https://github.com/frescobaldi/python-poppler-qt5"
SRC_URI="https://github.com/frescobaldi/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	app-text/poppler[qt5]
	dev-python/PyQt5[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

src_configure() {
	DISTUTILS_ARGS=(
		--jobs="$(makeopts_jobs)"
		--qmake="$(qt5_get_bindir)"/qmake
		--qmake-setting="$(qt5_get_qmake_args)"
		--verbose
	)
}
