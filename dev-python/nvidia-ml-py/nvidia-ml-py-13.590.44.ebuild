# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_PN=${PN/-/_}
PYTHON_COMPAT=( python3_{11..14} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 pypi

DESCRIPTION="Python bindings to the NVIDIA Management Library"
HOMEPAGE="
	https://pypi.org/project/nvidia-ml-py/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	x11-drivers/nvidia-drivers
"
DEPEND="${RDEPEND}"

src_prepare() {
	# don't install example.py
	sed -i "s/, 'example'//g" setup.py || die

	default
}

python_install_all() {
	distutils-r1_python_install_all

	if use examples; then
		dodoc -r example.py
	fi
}
