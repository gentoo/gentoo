# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

DOCS_BUILDER="mkdocs"
DOCS_DEPEND="
	dev-python/mkdocs-material
"

inherit python-single-r1 docs wrapper

DESCRIPTION="A GDB Enhanced Features for exploit devs & reversers"
HOMEPAGE="https://github.com/hugsy/gef"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/hugsy/gef"
else
	SRC_URI="https://github.com/hugsy/gef/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm ~ppc x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="test"
# Seem to hang right now?
RESTRICT="!test? ( test ) test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	dev-util/ropper[${PYTHON_SINGLE_USEDEP}]
	sys-devel/gdb[python,${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		dev-libs/capstone[python,${PYTHON_USEDEP}]
		dev-libs/keystone[python,${PYTHON_USEDEP}]
		dev-python/pylint[${PYTHON_USEDEP}]
		dev-util/unicorn[python,${PYTHON_USEDEP}]
	')"

BDEPEND="
	test? (
		$(python_gen_cond_dep '
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/pytest-xdist[${PYTHON_USEDEP}]
		')
	)"

DOCS=( README.md )

src_prepare() {
	default

	sed -i -e '/pylint/d' tests/requirements.txt || die
}

src_compile() {
	# Tries to compile tests
	:

	docs_compile
}

src_install() {
	insinto "/usr/share/${PN}"
	doins -r *.py

	python_optimize "${ED}/usr/share/${PN}"

	make_wrapper "gdb-gef" \
		"gdb -x \"/usr/share/${PN}/gef.py\"" || die

	einstalldocs
}

pkg_postinst() {
	einfo "\nUsage:"
	einfo "    ~$ gdb-gef <program>\n"
}
