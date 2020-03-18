# Copyright 2017-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=(python{3_6,3_7})
DISTUTILS_SINGLE_IMPL="1"
DISTUTILS_USE_SETUPTOOLS="rdepend"

inherit distutils-r1

if [[ "${PV}" == "99999999999999" ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://chromium.googlesource.com/external/gyp"
fi

DESCRIPTION="GYP (Generate Your Projects) meta-build system"
HOMEPAGE="https://gyp.gsrc.io/ https://chromium.googlesource.com/external/gyp"
if [[ "${PV}" == "99999999999999" ]]; then
	SRC_URI=""
else
	SRC_URI="https://home.apache.org/~arfrever/distfiles/${P}.tar.xz"
fi

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

BDEPEND=""
DEPEND=""
RDEPEND=""

src_test() {
	# More errors when DeprecationWarnings enabled.
	local -x PYTHONWARNINGS=""

	"${PYTHON}" gyptest.py --all --verbose
}
