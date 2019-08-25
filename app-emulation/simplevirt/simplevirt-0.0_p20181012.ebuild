# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=(
	"github.com/inconshreveable/mousetrap v1.0.0"
	"github.com/spf13/cobra v0.0.3"
	"github.com/spf13/pflag v1.0.2"
	"gopkg.in/check.v1 20d25e2804050c1cd24a7eea1e7a6447dd0e74ec github.com/go-check/check"
	"gopkg.in/yaml.v2 v2.2.1 github.com/go-yaml/yaml"
)

inherit linux-info golang-vcs-snapshot user

EGO_PN="github.com/rafaelmartins/simplevirt"
GIT_COMMIT="78d29d8fa11ce72af5f897430af7bb7d2947a32f"
GIT_VERSION="0.0.26-78d2"
ARCHIVE_URI="https://${EGO_PN}/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"

DESCRIPTION="Simple virtual machine manager for Linux (QEMU/KVM)"
HOMEPAGE="https://github.com/rafaelmartins/simplevirt"
SRC_URI="
	${ARCHIVE_URI}
	${EGO_VENDOR_URI}"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	virtual/logger
	app-emulation/qemu"

CONFIG_CHECK="~TUN ~BRIDGE"
ERROR_TUN="CONFIG_TUN: Universal TUN/TAP driver required to setup bridge networking"
ERROR_BRIDGE="CONFIG_BRIDGE: 802.1d Ethernet Bridging required to setup bridge networking"

pkg_setup() {
	enewgroup simplevirt

	linux-info_pkg_setup
}

src_compile() {
	pushd src/${EGO_PN} > /dev/null || die
	GOPATH="${S}" go install -v -ldflags "-X ${EGO_PN}.Version=${GIT_VERSION}" ./cmd/... || die
	popd > /dev/null || die
}

src_install() {
	dobin bin/simplevirtctl
	dosbin bin/simplevirtd

	newinitd "${FILESDIR}/simplevirtd.initd" simplevirtd
	newconfd "${FILESDIR}/simplevirtd.confd" simplevirtd

	dodoc "src/${EGO_PN}/README.md"

	keepdir /etc/simplevirt
}

src_test() {
	pushd src/${EGO_PN} > /dev/null || die
	GOPATH="${S}" go test -v ./pkg/... || die
	popd > /dev/null || die
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
