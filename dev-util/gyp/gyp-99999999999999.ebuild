# Copyright 2017-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=(python{3_7,3_8,3_9})
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

python_prepare_all() {
	distutils-r1_python_prepare_all

	sed -e "s/'  Linux %s' % ' '\.join(platform.linux_distribution())/'  Linux'/" -i gyptest.py || die
	sed \
		-e "s/import collections/import collections.abc/" \
		-e "s/collections\.MutableSet/collections.abc.MutableSet/" \
		-i pylib/gyp/common.py || die
	sed -e "s/the_dict_key is 'variables'/the_dict_key == 'variables'/" -i pylib/gyp/input.py || die
	sed \
		-e "s/import collections/import collections.abc/" \
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
