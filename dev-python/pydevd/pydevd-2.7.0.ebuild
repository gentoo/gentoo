# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1 toolchain-funcs

MY_P="pydev_debugger_${PV//./_}"

DESCRIPTION="PyDev.Debugger (used in PyDev, PyCharm and VSCode Python)"
HOMEPAGE="https://github.com/fabioz/PyDev.Debugger/"
SRC_URI="https://github.com/fabioz/PyDev.Debugger/archive/${MY_P}.tar.gz"
S="${WORKDIR}/PyDev.Debugger-${MY_P}"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ppc64 ~riscv sparc x86"

# After removing and recompiling the prebuilt lib the tests fail?
# For some reason the test suite is executing a slightly different gdb command
# then before, which is lacking the file name of the lib that was pre built:
# gdb: No symbol table is loaded. Use the "file" command
# This also happens outside of portage so it is not related to any *FLAGS
RESTRICT="test"

BDEPEND="
	test? (
		dev-python/untangle[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
	)
"

# Block against the version of debugpy that still bundles pydevd
RDEPEND="
	!<dev-python/debugpy-1.4.2
	sys-devel/gdb
"

distutils_enable_tests pytest

python_prepare_all() {
	distutils-r1_python_prepare_all

	# Drop -O3 and -flto compiler args
	sed -i \
		-e 's/extra_link_args = extra_compile_args\[\:\]/pass/g' \
		-e '/extra_compile_args/d' \
		setup.py || die

	# Clean up some prebuilt files
	rm -r third_party || die
	cd pydevd_attach_to_process || die

	# Remove these Windows files
	rm attach_{amd64,x86}.dll || die
	rm inject_dll_{amd64,x86}.exe || die
	rm run_code_on_dllmain_{amd64,x86}.dll || die
	rm -r windows winappdbg || die

	# Remove these MacOS files
	rm attach_x86_64.dylib || die

	# Remove these prebuilt linux files
	rm attach_linux_{amd64,x86}.so || die

	cd linux_and_mac || die
	rm compile_mac.sh || die
}

src_compile() {
	pushd pydevd_attach_to_process/linux_and_mac || die
	# recompile removed file (extracted from compile_linux.sh)
	$(tc-getBUILD_CXX) ${CXXFLAGS} ${CPPFLAGS} -o "attach_linux_${ARCH}.so" \
		${LDFLAGS} -nostartfiles attach.cpp -ldl || die
	mv "attach_linux_${ARCH}.so" ../ || die
	popd || die
	python_foreach_impl distutils-r1_python_compile
}

python_install_all() {
	distutils-r1_python_install_all
	# Remove this duplicate that is installed directly to /usr/
	# These files are also correctly installed to the python site-packages dir
	rm -r "${ED}/usr/pydevd_attach_to_process" || die
}
