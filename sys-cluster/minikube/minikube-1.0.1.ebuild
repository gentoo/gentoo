# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_6} )

inherit python-any-r1 golang-build golang-vcs-snapshot

EGO_PN="k8s.io/minikube"
ARCHIVE_URI="https://github.com/kubernetes/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Single Node Kubernetes Cluster"
HOMEPAGE="https://github.com/kubernetes/minikube https://kubernetes.io"
SRC_URI="${ARCHIVE_URI}"

LICENSE="Apache-2.0 BSD BSD-2 CC-BY-4.0 CC-BY-SA-4.0 CC0-1.0 GPL-2 ISC LGPL-3 MIT MPL-2.0 WTFPL-2 ZLIB || ( LGPL-3+ GPL-2 ) || ( Apache-2.0 LGPL-3+ ) || ( Apache-2.0 CC-BY-4.0 )"
SLOT="0"
IUSE="hardened libvirt"

DEPEND="dev-go/go-bindata
	${PYTHON_DEPS}
	libvirt? ( app-emulation/libvirt[qemu] )"
RDEPEND=">=sys-cluster/kubectl-1.14.0"

RESTRICT="test"

src_prepare() {
	default
	sed -i -e 's/ -s -w/ -w/' -e 's#.*GOBIN=$(GOPATH)/bin go get github.com/jteeuwen/go-bindata/...##' -e 's#$(GOPATH)/bin/go-bindata#/usr/bin/go-bindata#g' src/${EGO_PN}/Makefile || die
	sed -i -e "s/get_commit(), get_tree_state(), get_version()/get_commit(), 'gitTreeState=clean', get_version()/"  src/${EGO_PN}/hack/get_k8s_version.py || die
}

src_compile() {
	export -n GOCACHE XDG_CACHE_HOME
	export CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')"
	LDFLAGS="" GOFLAGS="-v" GOPATH="${WORKDIR}/${P}" emake -C src/${EGO_PN}  $(usex libvirt "out/docker-machine-driver-kvm2" "") out/minikube-linux-amd64
}

src_install() {
	pushd src/${EGO_PN} || die
	newbin out/minikube-linux-amd64 minikube
	use libvirt && dobin out/docker-machine-driver-kvm2
	dodoc -r docs CHANGELOG.md README.md
	popd || die
}

pkg_postinst() {
	elog "You may want to install the following optional dependency:"
	elog "  app-emulation/virtualbox or app-emulation/virtualbox-bin"
}
