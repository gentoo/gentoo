# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit python-any-r1 golang-build golang-vcs-snapshot

EGO_PN="k8s.io/minikube/..."
ARCHIVE_URI="https://github.com/kubernetes/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Single Node Kubernetes Cluster"
HOMEPAGE="https://github.com/kubernetes/minikube https://kubernetes.io"
SRC_URI="${ARCHIVE_URI}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND="dev-go/go-bindata
	${PYTHON_DEPS}"
RDEPEND=">=sys-cluster/kubectl-1.5.3"

RESTRICT="test"

src_prepare() {
	default
	sed -i -e 's#$(GOPATH)/bin/go-bindata#go-bindata#' -e 's#GOBIN=$(GOPATH)/bin go get github.com/jteeuwen/go-bindata/...##' src/${EGO_PN%/*}/Makefile || die
	sed -i -e "s/get_rev(), get_version(), get_tree_state()/get_rev(), get_version(), 'gitTreeState=clean'/"  src/${EGO_PN%/*}/hack/get_k8s_version.py || die
}

src_compile() {
	LDFLAGS="" GOPATH="${WORKDIR}/${P}" emake -C src/${EGO_PN%/*}
}

src_install() {
	pushd src/${EGO_PN%/*} || die
	dobin out/minikube out/localkube
	dodoc CHANGELOG.md DRIVERS.md README.md ROADMAP.md
	popd || die
}
