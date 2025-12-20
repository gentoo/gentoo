# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-env go-module shell-completion toolchain-funcs

DESCRIPTION="CLI and validation tools for Kubelet Container Runtime (CRI)"
HOMEPAGE="https://github.com/kubernetes-sigs/cri-tools"
SRC_URI="https://github.com/kubernetes-sigs/cri-tools/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD BSD-2 CC-BY-SA-4.0 ISC MIT MPL-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64"
RESTRICT="test"

DOCS=( docs {README,RELEASE,CHANGELOG,CONTRIBUTING}.md )

src_compile() {
	local GOOS=$(go-env_goos)
	CRICTL="build/bin/${GOOS}/${GOARCH}/crictl"
	emake VERSION="${PV}"

	if ! tc-is-cross-compiler; then
		"${CRICTL}" completion bash > crictl.bash || die
		"${CRICTL}" completion zsh > crictl.zsh || die
	fi
}

src_install() {
	einstalldocs
	dobin "${CRICTL}"

	if ! tc-is-cross-compiler; then
		newbashcomp crictl.bash crictl
		newzshcomp crictl.zsh _crictl
	fi
}
