# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit go-module shell-completion sysroot

# update on every bump
GIT_COMMIT=fc1869c7555df65250a17781e24ab077ad1db267

DESCRIPTION="the official gitlab command line interface"
HOMEPAGE="https://gitlab.com/gitlab-org/cli"
SRC_URI="https://gitlab.com/gitlab-org/cli/-/archive/v${PV}/${PN}-v${PV}.tar.bz2 -> ${P}.tar.bz2"
SRC_URI+=" https://github.com/gentoo-golang-dist/${PN}/releases/download/v${PV}/${P}-vendor.tar.xz"
S="${WORKDIR}/cli-v${PV}-${GIT_COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# tests communicate with gitlab.com and require a personal access token
RESTRICT="test"

BDEPEND=">=dev-lang/go-1.26.4"

QA_PRESTRIPPED=usr/bin/glab

src_unpack() {
	mkdir -p "${S}" || die
	ln -s "../${P}/vendor" "${S}/vendor" || die
	go-module_src_unpack
}

src_compile() {
	emake \
		BUILD_COMMIT_SHA=${GIT_COMMIT::8} \
		GLAB_VERSION=v${PV} \
		build manpage

	einfo "generating shell completion files"
	sysroot_try_run_prefixed bin/glab completion bash > "${T}"/glab.bash || die
	sysroot_try_run_prefixed bin/glab completion zsh > "${T}"/glab.zsh || die
	sysroot_try_run_prefixed bin/glab completion fish > "${T}"/glab.fish || die
}

src_install() {
	dobin bin/glab
	dodoc README.md
	doman share/man/man1/*

	[[ -s "${T}"/glab.bash ]] && newbashcomp "${T}"/glab.bash glab
	[[ -s "${T}"/glab.zsh ]] && newzshcomp "${T}"/glab.zsh _glab
	[[ -s "${T}"/glab.fish ]] && dofishcomp "${T}"/glab.fish
}
