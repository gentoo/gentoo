# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot systemd user tmpfiles

KEYWORDS="~amd64 ~arm64"
DESCRIPTION="An etcd backed network fabric for containers"
EGO_PN="github.com/coreos/flannel"
HOMEPAGE="https://github.com/coreos/flannel"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0 BSD ISC LGPL-3 MIT"
SLOT="0"
IUSE="hardened"
RESTRICT="test"

src_prepare() {
	default
	sed -e "s:^var Version =.*:var Version = \"${PV}\":" \
		-i "${S}/src/${EGO_PN}/version/version.go" || die
}

src_compile() {
	CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')"\
	GOPATH="${WORKDIR}/${P}" \
		go install -v -work -x ${EGO_BUILD_FLAGS} "${EGO_PN}"
	[[ -x bin/${PN} ]] || die
}

src_test() {
	GOPATH="${WORKDIR}/${P}" \
		go test -v -work -x "${EGO_PN}" || die
}

src_install() {
	newbin "bin/${PN}" ${PN}d
	cd "src/${EGO_PN}" || die
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
