# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 go-module

DESCRIPTION="CLI and validation tools for Kubelet Container Runtime (CRI)"
HOMEPAGE="https://github.com/kubernetes-sigs/cri-tools"
SRC_URI="https://github.com/kubernetes-sigs/cri-tools/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD BSD-2 CC-BY-SA-4.0 ISC MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-lang/go"

RESTRICT+=" test"

src_compile() {
	emake VERSION="${PV}"
	./build/bin/crictl completion bash > "crictl.bash" || die
	./build/bin/crictl completion zsh > "crictl.zsh" || die
}

src_install() {
	dobin ./build/bin/crictl

	newbashcomp crictl.bash crictl
	insinto /usr/share/zsh/site-functions
	newins crictl.zsh _crictl

	dodoc -r docs {README,RELEASE,CHANGELOG,CONTRIBUTING}.md
}
