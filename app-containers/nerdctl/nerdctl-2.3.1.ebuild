# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module optfeature shell-completion sysroot

EGIT_COMMIT="04f63fe15f3f8d77fe41e56ab7ff1d1f3e312860"

DESCRIPTION="Docker-compatible CLI for containerd, with support for Compose"
HOMEPAGE="https://github.com/containerd/nerdctl"
SRC_URI="
	https://github.com/containerd/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/containerd/${PN}/releases/download/v${PV}/${P}-go-mod-vendor.tar.gz
"

LICENSE="Apache-2.0"
LICENSE+=" BSD BSD-2 ISC MIT"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND=">=dev-lang/go-1.26.3"

src_unpack() {
	unpack "${P}.tar.gz"
	cd "${S}"
	unpack "${P}-go-mod-vendor.tar.gz"
	mv home/runner/work/nerdctl/nerdctl/vendor . || die
}

src_prepare() {
	default
	sed -e 's/TestGet/_&/' -i pkg/resolvconf/resolvconf_linux_test.go || die
}

src_compile() {
	emake VERSION=v${PV} REVISION="${EGIT_COMMIT}" GO_BUILD_LDFLAGS="-w"

	einfo "generating shell completion files"
	sysroot_try_run_prefixed ./_output/nerdctl completion bash > ${PN}.bash || die
	sysroot_try_run_prefixed ./_output/nerdctl completion zsh > ${PN}.zsh || die
	sysroot_try_run_prefixed ./_output/nerdctl completion fish > ${PN}.fish || die
}

src_install() {
	local emake_args=(
		DESTDIR="${D}"
		VERSION=v${PV}
		REVISION="${EGIT_COMMIT}"
		DOCDIR="${EPREFIX}/usr/share/doc/${PF}"
		PREFIX="${EPREFIX}/usr"
	)
	emake "${emake_args[@]}" install
	local DOCS=( README.md docs/* examples )
	einstalldocs

	[[ -s ${PN}.bash ]] && newbashcomp ${PN}.bash ${PN}
	[[ -s ${PN}.zsh ]] && newzshcomp ${PN}.zsh _${PN}
	[[ -s ${PN}.fish ]] && dofishcomp ${PN}.fish
}

pkg_postinst() {
	optfeature "rootless mode" "app-containers/slirp4netns sys-apps/rootlesskit"
}
