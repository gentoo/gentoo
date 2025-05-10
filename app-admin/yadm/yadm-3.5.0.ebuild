# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit python-any-r1 shell-completion

DESCRIPTION="Git based tool for managing dotfiles"
HOMEPAGE="https://github.com/yadm-dev/yadm"
SRC_URI="
	https://github.com/yadm-dev/yadm/archive/${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-crypt/gnupg
	app-shells/bash
	dev-vcs/git
"

BDEPEND="
	test? (
		${RDEPEND}
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			dev-python/pytest[${PYTHON_USEDEP}]
		')
		dev-tcltk/expect
	)
"

DOCS=( CHANGES README.md ${PN}.md )

python_check_deps() {
	python_has_version -b "dev-python/pytest[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_compile() {
	emake "${PN}.md"
}

src_test() {
	# prevent system config having influence on tests
	local -x GIT_CONFIG_NOSYSTEM=1

	# prevent git branch warning, it confuses tests
	local -x GIT_CONFIG_GLOBAL="${HOME}/.gitconfig"
	git config --global init.defaultBranch master || die "setting default branch name failed"

	local EPYTEST_DESELECT=(
		# requires envtpl, not packaged
		test/test_alt.py::test_alt_templates[t-envtpl]
		test/test_alt.py::test_alt_templates[template-envtpl]
		test/test_alt.py::test_alt_templates[yadm-envtpl]
		# requires esh
		test/test_alt.py::test_alt_templates[t-esh]
		test/test_alt.py::test_alt_templates[template-esh]
		test/test_alt.py::test_alt_templates[yadm-esh]
		test/test_unit_template_esh.py
		# requires j2cli
		test/test_alt.py::test_alt_templates[t-j2cli]
		test/test_alt.py::test_alt_templates[t-j2]
		test/test_alt.py::test_alt_templates[template-j2cli]
		test/test_alt.py::test_alt_templates[template-j2]
		test/test_alt.py::test_alt_templates[yadm-j2cli]
		test/test_alt.py::test_alt_templates[yadm-j2]
		test/test_unit_template_j2.py

		# needs old version of yadm
		test/test_upgrade.py::test_upgrade

		# Requires very specific versions to test against
		test/test_syntax.py
	)

	epytest
}

src_install() {
	einstalldocs

	dobin "${PN}"
	doman "${PN}.1"

	dobashcomp completion/bash/yadm
	dozshcomp completion/zsh/_${PN}
	dofishcomp completion/fish/${PN}.fish
}
