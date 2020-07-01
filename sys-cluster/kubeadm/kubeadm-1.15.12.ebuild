# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit golang-build golang-vcs-snapshot bash-completion-r1

EGO_PN="k8s.io/kubernetes"
ARCHIVE_URI="https://github.com/kubernetes/kubernetes/archive/v${PV}.tar.gz -> kubernetes-${PV}.tar.gz"

DESCRIPTION="CLI to Easily bootstrap a secure Kubernetes cluster"
HOMEPAGE="https://github.com/kubernetes/kubernetes https://kubernetes.io"
SRC_URI="${ARCHIVE_URI}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="=dev-lang/go-1.12*
	dev-go/go-bindata"

RESTRICT="test"

src_prepare() {
	default
	sed -i -e "/vendor\/github.com\/jteeuwen\/go-bindata\/go-bindata/d" -e "s/-s -w/-w/" src/${EGO_PN}/hack/lib/golang.sh || die
	sed -i -e "/export PATH/d" src/${EGO_PN}/hack/generate-bindata.sh || die
}

src_compile() {
	LDFLAGS="" GOPATH="${WORKDIR}/${P}" emake -j1 -C src/${EGO_PN} WHAT=cmd/${PN} GOFLAGS=-v
	pushd src/${EGO_PN} || die
	_output/bin/${PN} completion bash > ${PN}.bash || die
	_output/bin/${PN} completion zsh > ${PN}.zsh || die
	popd || die
}

src_install() {
	pushd src/${EGO_PN} || die
	dobin _output/bin/${PN}

	newbashcomp ${PN}.bash ${PN}
	insinto /usr/share/zsh/site-functions
	newins ${PN}.zsh _${PN}

	popd || die
}
