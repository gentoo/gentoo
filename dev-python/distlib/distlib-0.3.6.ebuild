# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="Low-level components of distutils2/packaging"
HOMEPAGE="
	https://pypi.org/project/distlib/
	https://github.com/pypa/distlib
"
SRC_URI="
	https://github.com/pypa/distlib/archive/${PV}.tar.gz -> ${P}.gh.tar.gz
"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

# pypiserver is called as external executable
# openpyxl installs invalid metadata that breaks distlib
BDEPEND="
	test? (
		dev-python/pypiserver
		!!<dev-python/openpyxl-3.0.3[${PYTHON_USEDEP}]
	)
"

src_prepare() {
	# make sure they're not used
	rm tests/pypi-server-standalone.py || die

	# use system pypiserver instead of broken bundled one
	eapply "${FILESDIR}"/distlib-0.3.2-system-pypiserver.py || die

	# doesn't work with our patched pip
	sed -i -e '/PIP_AVAIL/s:True:False:' tests/test_wheel.py || die

	# broken with pypy3
	sed -i -e 's:test_custom_shebang:_&:' tests/test_scripts.py || die
	# broken with py3.11, doesn't look important
	sed -i -e 's:test_sequencer_basic:_&:' tests/test_util.py || die
	# https://bugs.gentoo.org/843839
	sed -i -e 's:test_interpreter_args:_&:' tests/test_scripts.py || die

	distutils-r1_src_prepare
}

python_test() {
	local -x SKIP_ONLINE=1
	local -x PYTHONHASHSEED=0

	# disable system-site-packages -- distlib has no deps, and is very
	# fragile to packages actually installed on the system
	sed -i -e '/system-site-packages/s:true:false:' \
		"${BUILD_DIR}/install${EPREFIX}/usr/bin/pyvenv.cfg" || die

	"${EPYTHON}" tests/test_all.py -v -x ||
		die "Tests failed with ${EPYTHON}"
}
