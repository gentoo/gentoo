# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# bash-completion-r1 can be added once we can generate completion scripts
inherit go-module

DESCRIPTION="A simple JIRA commandline client in Go"
HOMEPAGE="https://github.com/go-jira/jira"
SRC_URI="https://github.com/go-jira/jira/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD-2 BSD ISC MIT MIT-with-advertising"
SLOT="0"
KEYWORDS="amd64"

S="${WORKDIR}/jira-${PV}"

src_compile() {
	ego build ./cmd/jira
	# these cause failures.
#	./jira --completion-script-bash > jira.bash || die
#	./jira --completion-script-zsh > jira.zsh || die
}

src_install() {
	dobin jira
	dodoc {CHANGELOG,README}.md
	# This can be uncommented once we can generate completion scripts
#	newbashcomp jira.bash jira
#	insinto /usr/share/zsh/site-functions
#	newins jira.zsh _jira
}
