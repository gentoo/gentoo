# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
DISTUTILS_SINGLE_IMPL=1
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 wrapper

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
	~dev-python/gdb-pt-dump-0.0.0_p20231111[${PYTHON_SINGLE_USEDEP}]
	sys-devel/gdb[python,${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-libs/capstone-5.0_rc4[python,${PYTHON_USEDEP}]
		>=dev-python/psutil-5.9.5[${PYTHON_USEDEP}]
		>=dev-python/pycparser-2.21[${PYTHON_USEDEP}]
		>=dev-python/pyelftools-0.29[${PYTHON_USEDEP}]
		>=dev-python/pygments-2.15.1[${PYTHON_USEDEP}]
		>=dev-python/tabulate-0.9.0[${PYTHON_USEDEP}]
		>=dev-python/typing-extensions-4.6.1[${PYTHON_USEDEP}]
		>=dev-util/pwntools-4.10.0[${PYTHON_USEDEP}]
		>=dev-util/ROPgadget-7.2[${PYTHON_USEDEP}]
		>=dev-util/unicorn-2.0.1[python,${PYTHON_USEDEP}]
	')
"

src_prepare() {
	if [[ ${PV} != 99999999 ]]; then
		sed -e "s/__version__ = '\(.*\)'/__version__ = '${PV}'/" \
			-i pwndbg/lib/version.py || die
	fi

	default
}

src_install() {
	distutils-r1_src_install

	insinto /usr/share/${PN}
	doins gdbinit.py

	# Signal pwndbg not to create it's own python venv (Bug #918705).
	# See: https://github.com/pwndbg/pwndbg/commit/139b7542cd9567eaff32bd713df971b6ac5b81de
	touch "${ED}/usr/share/${PN}/.skip-venv" || die

	python_optimize "${ED}"/usr/share/${PN}

	make_wrapper "pwndbg" \
		"gdb -x \"${EPREFIX}/usr/share/${PN}/gdbinit.py\"" || die

	dodoc {README,DEVELOPING,FEATURES}.md
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
