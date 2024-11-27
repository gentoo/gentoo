# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..12} )
inherit bash-completion-r1 python-any-r1

DESCRIPTION="Git utilities -- repo summary, repl, changelog population, and many more"
HOMEPAGE="https://github.com/tj/git-extras"
SRC_URI="https://github.com/tj/git-extras/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=app-shells/bash-4.0:*
	dev-vcs/git
"
BDEPEND="
	test? (
		$(python_gen_any_dep '
			>=dev-python/gitpython-3.1.40[${PYTHON_USEDEP}]
			>=dev-python/pytest-7.2[${PYTHON_USEDEP}]
			dev-python/testpath[${PYTHON_USEDEP}]
		')
	)
"

python_check_deps() {
	python_has_version ">=dev-python/gitpython-3.1.40[${PYTHON_USEDEP}]" &&
		python_has_version ">=dev-python/pytest-7.2[${PYTHON_USEDEP}]" &&
		python_has_version "dev-python/testpath[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	default

	# For now, don't force including the git completion
	sed -i -e "1 i source $(get_bashcompdir)\/git" etc/bash_completion.sh || die
}

src_compile() {
	return
}

src_test() {
	epytest
}

src_install() {
	emake \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}/usr" \
		SYSCONFDIR="${EPREFIX}/etc" \
		COMPL_DIR="${D}/$(get_bashcompdir)" \
		install

	# TODO: Unfortunately, none of the completion seems to
	# actually work for me yet(?)

	newbashcomp "${S}"/etc/bash_completion.sh ${PN}

	insinto /usr/share/zsh/site-functions
	newins "${S}"/etc/${PN}-completion.zsh _${PN}

	insinto /usr/share/fish/vendor_completions.d
	doins "${S}"/etc/${PN}.fish
}
