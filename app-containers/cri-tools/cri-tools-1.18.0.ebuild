# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit bash-completion-r1 go-module
MY_PV="v${PV/_beta/-beta.}"

DESCRIPTION="CLI and validation tools for Kubelet Container Runtime (CRI)"
HOMEPAGE="https://github.com/kubernetes-sigs/cri-tools"
SRC_URI="https://github.com/kubernetes-sigs/cri-tools/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD BSD-2 CC-BY-SA-4.0 ISC MIT MPL-2.0"
SLOT="0"
KEYWORDS="amd64"

RESTRICT+=" test"

src_compile() {
	emake VERSION="${MY_PV}"
	_output/crictl completion bash > ${PN}.bash || die
	_output/crictl completion zsh > ${PN}.zsh || die
}

src_install() {
	dobin _output/crictl

	newbashcomp ${PN}.bash ${PN}
	insinto /usr/share/zsh/site-functions
	newins ${PN}.zsh _${PN}

	dodoc -r docs {README,RELEASE,CHANGELOG,CONTRIBUTING}.md
}
