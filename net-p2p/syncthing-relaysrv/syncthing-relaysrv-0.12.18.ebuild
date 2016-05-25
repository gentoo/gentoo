# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

EGO_PN="github.com/syncthing/relaysrv"
EGIT_COMMIT=v${PV}

inherit golang-vcs-snapshot systemd user versionator

DESCRIPTION="Syncthing relay server"
HOMEPAGE="https://syncthing.net"
SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"
IUSE=""

DEPEND=""
RDEPEND=""

DOCS="README.md"

USER=syncthing-relaysrv
BINARY=syncthing-relaysrv

pkg_setup() {
	enewgroup ${USER}
	enewuser ${USER} -1 -1 /var/lib/${USER} ${USER}
}

src_compile() {
	cd "src/${EGO_PN}" || die "build failed"
	export GOPATH="$(pwd)/Godeps/_workspace"
	go build -i -v -ldflags -w -o ${BINARY} || die "build failed"
}

src_install() {
	dobin "src/${EGO_PN}/${BINARY}"

	# openrc and systemd daemon routines
	newconfd "${FILESDIR}/syncthing-relaysrv.confd" syncthing-relaysrv
	newinitd "${FILESDIR}/syncthing-relaysrv.initd" syncthing-relaysrv
	systemd_newunit "${FILESDIR}/syncthing-relaysrv.service" \
		syncthing-relaysrv.service
}
