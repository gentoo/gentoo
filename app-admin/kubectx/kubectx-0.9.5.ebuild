# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module shell-completion

DESCRIPTION="Fast way to switch between clusters and namespaces in kubectl"
HOMEPAGE="https://github.com/ahmetb/kubectx"
SRC_URI="https://github.com/ahmetb/kubectx/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~arthurzam/distfiles/app-admin/${PN}/${P}-deps.tar.xz"

LICENSE="Apache-2.0"
# Dependent licenses
LICENSE+=" Apache-2.0 BSD BSD-2 ISC MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

src_compile() {
	ego build -trimpath -ldflags "-w -s" ./cmd/{kubectx,kubens}
}

src_install() {
	dobin kubectx kubens

	newbashcomp completion/kubectx.bash kubectx
	newbashcomp completion/kubens.bash kubens
	newzshcomp completion/_kubectx.zsh _kubectx
	newzshcomp completion/_kubens.zsh _kubens
	dofishcomp completion/{kubectx,kubens}.fish
}
