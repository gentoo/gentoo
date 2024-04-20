# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit bash-completion-r1 go-module

DESCRIPTION="Fast way to switch between clusters and namespaces in kubectl"
HOMEPAGE="https://github.com/ahmetb/kubectx"
SRC_URI="https://github.com/ahmetb/kubectx/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

src_compile() {
	GOBIN="${S}"/bin ego install ./cmd/kube{ctx,ns}
}

src_install() {
	dobin bin/*

	insinto /usr/share/zsh/site-functions
	newins completion/kubectx.zsh _kubectx
	newins completion/kubens.zsh _kubens

	newbashcomp completion/kubectx.bash kubectx
	newbashcomp completion/kubens.bash kubens
}
