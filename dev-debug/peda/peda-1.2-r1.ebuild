# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

inherit python-single-r1 wrapper

DESCRIPTION="Python Exploit Development Assistance for GDB"
HOMEPAGE="https://github.com/longld/peda"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/longld/peda"
else
	SRC_URI="https://github.com/longld/peda/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86"
fi

LICENSE="CC-BY-NC-SA-3.0"
SLOT="0"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-debug/gdb[python,${PYTHON_SINGLE_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
	')
"

PATCHES=(
	"${FILESDIR}/${P}-gdb_logging.patch"
	"${FILESDIR}/${P}-python3_14.patch"
)

src_prepare() {
	default

	# File was remove in upstream patch ${P}-python3_14.patch. To keep the
	# patch file size low, we remove this file directly instead via the patch.
	rm lib/six.py || die
}

src_install() {
	insinto /usr/share/${PN}
	doins -r lib/ *.py

	python_optimize "${ED}"/usr/share/${PN}

	make_wrapper "gdb-peda" \
		"gdb -x \"${EPREFIX}/usr/share/${PN}/peda.py\"" || die

	dodoc README{,.md}
}

pkg_postinst() {
	einfo "\nUsage:"
	einfo "    ~$ gdb-peda <program>\n"
}
