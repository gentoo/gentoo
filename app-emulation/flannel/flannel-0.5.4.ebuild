# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit systemd user

KEYWORDS="~amd64"
DESCRIPTION="An etcd backed network fabric for containers"
GO_PN="github.com/coreos/flannel"
HOMEPAGE="https://${GO_PN}"
SRC_URI="https://${GO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND=">=dev-lang/go-1.4:="
RDEPEND=""

src_prepare() {
	local line
	sed -e 's:go build:[[ ${0##*/} == test ]] || \0 -v -x:' -i build || die
	sed -e 's:go test:\0 -v:' -i test || die

	# remote_test.go:98: GetNetworkConfig failed: Get http://127.0.0.1:9999/v1/_/config: dial tcp 127.0.0.1:9999: getsockopt: connection refused
	sed -e 's:^func TestRemote:func _TestRemote:' -i remote/remote_test.go || die
}

src_compile() {
	"${BASH}" -ex ./build || die 'Build failed'
}

src_test() {
	"${BASH}" -ex ./test || die 'Tests failed'
}

src_install() {
	dobin bin/*
	exeinto /usr/libexec/flannel
	doexe dist/mk-docker-opts.sh
	insinto /etc/systemd/system/docker.service.d
	newins "${FILESDIR}/flannel-docker.conf" flannel.conf
	systemd_newtmpfilesd "${FILESDIR}/flannel.tmpfilesd" flannel.conf
	systemd_dounit "${FILESDIR}/flanneld.service"
}
