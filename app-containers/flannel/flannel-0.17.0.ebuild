# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module systemd tmpfiles

KEYWORDS="~amd64 ~arm64"
DESCRIPTION="An etcd backed network fabric for containers"
HOMEPAGE="https://github.com/flannel-io/flannel"
SRC_URI="https://github.com/flannel-io/flannel/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD ISC LGPL-3 MIT"
SLOT="0"
IUSE="hardened"

RESTRICT+=" test"

src_prepare() {
	default
	sed -e "s:^var Version =.*:var Version = \"${PV}\":" \
		-i "${S}/version/version.go" || die
}

src_compile() {
	CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')"\
	go build -o dist/flanneld -ldflags "
		-X github.com/flannel-io/flannel/version.Version=v${PV}
		-extldflags \"-static\"" . || die
}

src_test() {
	GOPATH="${WORKDIR}/${P}" \
		go test -v -work -x "${EGO_PN}" || die
}

src_install() {
	dobin dist/${PN}d
	exeinto /usr/libexec/flannel
	doexe dist/mk-docker-opts.sh
	insinto /etc/systemd/system/docker.service.d
	newins "${FILESDIR}/flannel-docker.conf" flannel.conf
	newinitd "${FILESDIR}"/flanneld.initd flanneld
	newconfd "${FILESDIR}"/flanneld.confd flanneld
	keepdir /var/log/${PN}
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/flanneld.logrotated flanneld
	newtmpfiles "${FILESDIR}/flannel.tmpfilesd" flannel.conf
	systemd_dounit "${FILESDIR}/flanneld.service"
	dodoc README.md
}

pkg_postinst() {
	tmpfiles_process flannel.conf
}
