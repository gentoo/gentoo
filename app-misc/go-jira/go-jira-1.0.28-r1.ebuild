# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module shell-completion toolchain-funcs

DESCRIPTION="A simple JIRA commandline client in Go"
HOMEPAGE="https://github.com/go-jira/jira"
SRC_URI="https://github.com/go-jira/jira/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"
S=${WORKDIR}/jira-${PV}

LICENSE="Apache-2.0"
# Dependent licenses
LICENSE+=" BSD"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	ego build -o jira ./cmd/jira

	if ! tc-is-cross-compiler; then
		elog "generating shell completion files"
		# those commands exit OK with 1, so we can't use die

		./jira --completion-script-bash > jira.bash
		grep -q "complete -F" jira.bash || die "bash completion script is invalid"

		./jira --completion-script-zsh > jira.zsh
		grep -q "compdef jira" jira.zsh || die "zsh completion script is invalid"
	fi
}

src_install() {
	dobin jira
	dodoc {CHANGELOG,README}.md

	if ! tc-is-cross-compiler; then
		newbashcomp jira.bash jira
		newzshcomp jira.zsh _jira
	else
		ewarn "Shell completion files not installed!"
	fi
}
