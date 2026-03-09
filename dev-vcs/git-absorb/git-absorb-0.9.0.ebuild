# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES=""
inherit cargo shell-completion

DESCRIPTION="Automatically absorb staged changes into git current branch"
HOMEPAGE="https://github.com/tummychow/git-absorb"
SRC_URI="https://github.com/tummychow/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-crate-dist/${PN}/releases/download/${PV}/${P}-crates.tar.xz"

LICENSE="BSD"
# Dependent crate licenses
LICENSE+=" Apache-2.0 MIT Unicode-DFS-2016"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	>=dev-libs/libgit2-1.9:=
	<dev-libs/libgit2-1.10
"
DEPEND="${RDEPEND}"
BDEPEND="app-text/asciidoc"

DOCS=( README.md )

QA_FLAGS_IGNORED="usr/bin/${PN}"

src_compile() {
	export LIBGIT2_NO_VENDOR=1

	cargo_src_compile

	GIT_ABSORB_BIN="$(cargo_target_dir)/${PN}"

	emake -C Documentation

	# Prepare shell completion generation
	mkdir completions || die
	local shell
	for shell in bash fish zsh; do
		"${GIT_ABSORB_BIN}" --gen-completions \
					 ${shell} \
					 > completions/${PN}.${shell} \
			|| die
	done
}

src_install() {
	cargo_src_install
	doman Documentation/${PN}.1

	newbashcomp "completions/${PN}.bash" "${PN}"
	dofishcomp "completions/${PN}.fish"
	dozshcomp "completions/${PN}.zsh"

	default
}
