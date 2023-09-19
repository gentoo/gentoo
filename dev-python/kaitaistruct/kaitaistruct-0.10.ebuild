# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Kaitai Struct runtime for Python"
HOMEPAGE="
	https://kaitai.io/
	https://github.com/kaitai-io/kaitai_struct_python_runtime/
	https://pypi.org/project/kaitaistruct/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~riscv ~x86"
