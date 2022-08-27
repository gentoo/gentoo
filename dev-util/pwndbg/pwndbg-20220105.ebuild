# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )

inherit python-single-r1 wrapper

DESCRIPTION="A GDB plug-in that makes debugging with GDB suck less"
HOMEPAGE="https://github.com/pwndbg/pwndbg"

if [[ ${PV} == "99999999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/pwndbg/pwndbg"
else
	MY_PV="${PV:0:4}.${PV:4:2}.${PV:6:2}"
	SRC_URI="https://github.com/pwndbg/pwndbg/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

LICENSE="MIT"
SLOT="0"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	sys-devel/gdb[python,${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		dev-libs/capstone[python,${PYTHON_USEDEP}]
		dev-python/future[${PYTHON_USEDEP}]
		dev-python/isort[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pycparser[${PYTHON_USEDEP}]
		dev-python/pyelftools[${PYTHON_USEDEP}]
		dev-python/python-ptrace[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
		dev-python/pygments[${PYTHON_USEDEP}]
		dev-util/ROPgadget[${PYTHON_USEDEP}]
		dev-util/unicorn[python,${PYTHON_USEDEP}]
	')"

src_prepare() {
	if [[ ${PV} != *9999 ]]; then
		sed -e "s/__version__ = '\(.*\)'/__version__ = '${PV}'/" \
			-i pwndbg/version.py || die
	fi

	python_fix_shebang "${S}"
	default
}

src_install() {
	insinto /usr/share/${PN}
	doins -r pwndbg/ gdbinit.py # ida_script.py

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
