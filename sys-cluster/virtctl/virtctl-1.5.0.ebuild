# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module optfeature shell-completion

# git rev-parse HEAD
MY_GIT_COMMIT="522b44c0ce8d1909618324cb083d69e5c7a0a234"

MY_PN="kubevirt"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Control virtual machine related operations on your kubernetes cluster"
HOMEPAGE="https://kubevirt.io https://github.com/kubevirt/kubevirt"
SRC_URI="https://github.com/kubevirt/${MY_PN}/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~concord/distfiles/${MY_P}-deps.tar.xz"
S="${WORKDIR}/${MY_P}"

LICENSE="Apache-2.0 BSD-2 BSD ISC MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="test"

src_compile() {
	ego build -o ./bin/virtctl -ldflags "
		-X kubevirt.io/client-go/version.buildDate=$(date -u +'%Y-%m-%dT%H:%M:%SZ')
		-X kubevirt.io/client-go/version.gitCommit=${MY_GIT_COMMIT}
		-X kubevirt.io/client-go/version.gitTreeState=clean
		-X kubevirt.io/client-go/version.gitVersion=v${PV}
		" ./cmd/virtctl
}

src_install() {
	dobin bin/virtctl

	bin/virtctl completion bash >./virtctl.bash || die "Failed generating bash completions"
	newbashcomp ./virtctl.bash virtctl

	bin/virtctl completion zsh >./virtctl.zsh || die "Failed generating zsh completions"
	newzshcomp ./virtctl.zsh _virtctl
}

pkg_postinst() {
	optfeature "graphical console for use with VNC connections" app-emulation/virt-viewer
}
