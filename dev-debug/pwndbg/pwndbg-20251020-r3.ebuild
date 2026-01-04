# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
DISTUTILS_SINGLE_IMPL=1
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="A GDB plug-in that makes debugging with GDB suck less"
HOMEPAGE="https://github.com/pwndbg/pwndbg"

if [[ ${PV} == "99999999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/pwndbg/pwndbg"
else
	MY_PV="${PV:0:4}.${PV:4:2}.${PV:6:2}"
	SRC_URI="https://github.com/pwndbg/pwndbg/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

LICENSE="MIT"
SLOT="0"

RDEPEND="
	dev-debug/gdb[python,${PYTHON_SINGLE_USEDEP}]
	~dev-python/gdb-pt-dump-0.0.0_p20240401[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-libs/capstone-6.0.0_alpha5[python,${PYTHON_USEDEP}]
		>=dev-python/psutil-7.0.0[${PYTHON_USEDEP}]
		>=dev-python/pycparser-2.23[${PYTHON_USEDEP}]
		>=dev-python/pyelftools-0.32[${PYTHON_USEDEP}]
		>=dev-python/pygments-2.19.2[${PYTHON_USEDEP}]
		>=dev-python/requests-2.32.5[${PYTHON_USEDEP}]
		>=dev-python/rich-14.1.0[${PYTHON_USEDEP}]
		>=dev-python/sortedcontainers-2.4.0[${PYTHON_USEDEP}]
		>=dev-python/tabulate-0.9.0[${PYTHON_USEDEP}]
		>=dev-python/typing-extensions-4.15.0[${PYTHON_USEDEP}]
		>=dev-util/pwntools-4.14.1[${PYTHON_USEDEP}]
		>=dev-util/ROPgadget-7.6[${PYTHON_USEDEP}]
		>=dev-util/unicorn-2.1.4[python,${PYTHON_USEDEP}]
	')
"

# Tests are architectur-specific (precompiled binaries)
RESTRICT="test"

src_install() {
	distutils-r1_src_install

	insinto /usr/share/${PN}
	doins gdbinit.py

	python_optimize "${ED}"/usr/share/${PN}

	dodoc README.md
	dodoc -r docs
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		einfo "\nUsage:"
		einfo "    ~$ pwndbg <program>"
		ewarn "\nWARNING!!!"
		ewarn "Some pwndbg commands only works with libc debug symbols.\n"
		ewarn "See also:"
		ewarn " * https://github.com/pentoo/pentoo-overlay/issues/521#issuecomment-548975884"
		ewarn " * https://sourceware.org/gdb/onlinedocs/gdb/Separate-Debug-Files.html"
		ewarn " * https://wiki.gentoo.org/wiki/Debugging"
	fi
}
