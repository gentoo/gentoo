# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module shell-completion

DESCRIPTION="Distributed, offline-first bug tracker embedded in git"
HOMEPAGE="https://github.com/git-bug/git-bug"
SRC_URI="https://github.com/git-bug/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~laumann/distfiles/${CATEGORY}/${PN}/${P}-deps.tar.xz"

LICENSE="GPL-3"
# Dependent licenses
LICENSE+=" Apache-2.0 BSD-2 BSD ISC MIT MPL-2.0 Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

BDEPEND=">=dev-lang/go-1.24.0"

QA_PRESTRIPPED=usr/bin/git-bug

src_compile() {
	ego generate
	local ego_build_args=(
		-ldflags "-s -w -X github.com/git-bug/git-bug/commands.GitLastTag=${PV} -X github.com/git-bug/git-bug/commands.GitExactTag=${PV}"
		-o ${PN}
	)
	ego build "${ego_build_args[@]}"
}

src_test() {
	# TestValidateProject fails with FEATURES=network-sandbox
	# TestGitFileHandlers appears to be brittle, see bug #982080 and
	# https://github.com/git-bug/git-bug/issues/1591
	CI=true ego test -v ./... -skip "TestValidateProject|TestGitFileHandlers"
}

src_install() {
	dobin git-bug
	doman doc/man/*.1
	dobashcomp misc/completion/bash/git-bug
	newzshcomp misc/completion/zsh/git-bug _git-bug
	newfishcomp misc/completion/fish/git-bug git-bug.fish
}
