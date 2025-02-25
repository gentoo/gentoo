# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Manage file system object mapping via symlinks"
HOMEPAGE="https://www.seichter.de/stown/"
SRC_URI="https://github.com/rseichter/stown/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
BDEPEND="test? ( app-text/tree )"
HTML_DOCS=( "${S}"/docs/index.html )

distutils_enable_tests unittest

python_test() {
	eunittest tests
}
