# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/ksonnet/ksonnet"

inherit golang-build golang-vcs-snapshot bash-completion-r1

ARCHIVE_URI="https://github.com/ksonnet/ksonnet/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="CLI-supported framework for extensible Kubernetes configurations"
HOMEPAGE="https://github.com/ksonnet/ksonnet http://ksonnet.heptio.com/"
SRC_URI="${ARCHIVE_URI}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RESTRICT="test"

src_prepare() {
	default
	sed -i -e "s/EXTRA_GO_FLAGS =/EXTRA_GO_FLAGS = -v /"\
		-e "s/VERSION =.*/VERSION = ${PV}/" src/${EGO_PN}/Makefile || die
}

src_compile() {
	pushd src/${EGO_PN} || die
	GOPATH="${S}" emake ks
	popd || die
}

src_install() {
	pushd src/${EGO_PN} || die
	dobin ks
	dodoc README.md
	popd || die
}
