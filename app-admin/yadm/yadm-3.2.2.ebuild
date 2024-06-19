# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
inherit bash-completion-r1 python-any-r1

DESCRIPTION="Git based tool for managing dotfiles"
HOMEPAGE="https://github.com/TheLocehiliosan/yadm"
SRC_URI="
	https://github.com/TheLocehiliosan/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~ppc64 ~x86"
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

	# un-hardcode path to tmp, otherwise encryption tests fail
	sed -e "/^cache_dir/s@/tmp@${T}@" -i pytest.ini || die "cannot patch cache dir"

	local EPYTEST_DESELECT=(
		test/test_alt.py # requires envtpl, not packaged
		test/test_compat_jinja.py # ditto
		test/test_unit_template_j2.py # ditto
		test/test_syntax.py # needs new yamllint, not packaged yet
		test/test_upgrade.py::test_upgrade # needs old version of yadm
		test/test_compat_alt.py # tests obsolete features, broken
		test/test_unit_template_esh.py # requires esh, not packaged
		test/test_encryption.py::test_symmetric_encrypt[clean-encrypt_exists-bad_phrase] # hangs in sandbox
		test/test_encryption.py::test_symmetric_encrypt[overwrite-encrypt_exists-bad_phrase] # ditto
	)

	epytest
}

src_install() {
	einstalldocs

	dobin "${PN}"
	doman "${PN}.1"

	dobashcomp completion/bash/yadm

	insinto /usr/share/zsh/site-functions
	doins completion/zsh/_${PN}

	insinto /usr/share/fish/vendor_completions.d
	doins completion/fish/${PN}.fish
}
