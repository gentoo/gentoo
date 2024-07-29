# Copyright 2017-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_SINGLE_IMPL="1"

inherit distutils-r1

DESCRIPTION="GYP (Generate Your Projects) meta-build system"
HOMEPAGE="https://gyp.gsrc.io/ https://chromium.googlesource.com/external/gyp"

if [[ "${PV}" == "99999999999999" ]]; then
	EGIT_REPO_URI="https://chromium.googlesource.com/external/gyp"
	inherit git-r3
else
	SRC_URI="https://home.apache.org/~arfrever/distfiles/${P}.tar.xz"
	KEYWORDS="amd64 ~arm64 ~loong ~ppc64 x86"
fi

LICENSE="BSD"
SLOT="0"
IUSE=""

BDEPEND=""
DEPEND=""
RDEPEND=""

python_prepare_all() {
	distutils-r1_python_prepare_all

	sed -e "s/'  Linux %s' % ' '\.join(platform.linux_distribution())/'  Linux'/" -i gyptest.py || die
	sed \
		-e "s/^import collections/import collections.abc/" \
		-e "s/collections\.MutableSet/collections.abc.MutableSet/" \
		-i pylib/gyp/common.py || die
	sed -e "s/the_dict_key is 'variables'/the_dict_key == 'variables'/" -i pylib/gyp/input.py || die
	sed \
		-e "s/^import collections/import collections.abc/" \
		-e "s/collections\.Iterable/collections.abc.Iterable/" \
		-i pylib/gyp/msvs_emulation.py || die
	sed \
		-e "s/os\.environ\['PRESERVE'\] is not ''/os.environ['PRESERVE'] != ''/" \
		-e "s/conditions is ()/conditions == ()/" \
		-i test/lib/TestCmd.py || die
}

python_test() {
	# More errors with DeprecationWarnings enabled.
	local -x PYTHONWARNINGS=""

	"${PYTHON}" gyptest.py --all --verbose
}
