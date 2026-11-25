# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module shell-completion

DESCRIPTION="Fast way to switch between clusters and namespaces in kubectl"
HOMEPAGE="https://github.com/ahmetb/kubectx"
SRC_URI="https://github.com/ahmetb/kubectx/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-golang-dist/${PN}/releases/download/v${PV}/${P}-vendor.tar.xz"

LICENSE="Apache-2.0"
# Dependent licenses
LICENSE+=" Apache-2.0 BSD ISC MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

BDEPEND=">=dev-lang/go-1.25.0"

src_compile() {
	ego build -trimpath -ldflags "-w" ./cmd/{kubectx,kubens}
}

src_install() {
	dobin kubectx kubens

	newbashcomp completion/kubectx.bash kubectx
	newbashcomp completion/kubens.bash kubens
	bashcomp_alias kubectx kctx
	bashcomp_alias kubens kns
	newzshcomp completion/_kubectx.zsh _kubectx
	newzshcomp completion/_kubens.zsh _kubens
	dofishcomp completion/{kubectx,kubens}.fish
}
