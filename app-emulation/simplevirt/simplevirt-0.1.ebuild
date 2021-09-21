# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module linux-info

DESCRIPTION="Simple virtual machine manager for Linux (QEMU/KVM)"
HOMEPAGE="https://github.com/rafaelmartins/simplevirt"

EGO_SUM=(
	"github.com/inconshreveable/mousetrap v1.0.0"
	"github.com/inconshreveable/mousetrap v1.0.0/go.mod"
	"github.com/spf13/cobra v0.0.3"
	"github.com/spf13/cobra v0.0.3/go.mod"
	"github.com/spf13/pflag v1.0.2"
	"github.com/spf13/pflag v1.0.2/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/yaml.v2 v2.2.1"
	"gopkg.in/yaml.v2 v2.2.1/go.mod"
	)
go-module_set_globals
SRC_URI="https://github.com/rafaelmartins/simplevirt/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

LICENSE="Apache-2.0 BSD-2 BSD MIT"
SLOT="0"
KEYWORDS=""

RDEPEND="
	acct-group/simplevirt
	virtual/logger
	app-emulation/qemu"

CONFIG_CHECK="~TUN ~BRIDGE"
ERROR_TUN="CONFIG_TUN: Universal TUN/TAP driver required to setup bridge networking"
ERROR_BRIDGE="CONFIG_BRIDGE: 802.1d Ethernet Bridging required to setup bridge networking"

src_compile() {
	go build -ldflags "
		-X github.com/rafaelmartins/simplevirt.Version=${PV}" ./cmd/... || die
}

src_install() {
	dobin simplevirtctl
	dosbin simplevirtd

	newinitd "${FILESDIR}/simplevirtd.initd" simplevirtd
	newconfd "${FILESDIR}/simplevirtd.confd" simplevirtd

	dodoc README.md

	keepdir /etc/simplevirt
}

src_test() {
	go test -v ./pkg/... || die
}

pkg_postinst() {
	elog
	elog "To use simplevirt, the simplevirtd daemon must be running as root."
	elog "To automatically start the daemon at boot, add it to the default runlevel:"
	elog "  rc-update add simplevirtd default"
	elog
	elog "systemd is not supported for now."
	elog
	elog "To use simplevirtctl as a non-root user, add yourself to the 'simplevirt' group:"
	elog "  usermod -aG simplevirt youruser"
	elog
}
