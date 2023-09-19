# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module
# uncomment the first setting of MY_PV for a normal release
# MY_PV="v${PV/_rc/-rc.}"
# set MY_PV to the full commit hash for a snapshot release
MY_PV_HASH=
HOMEPAGE="https://github.com/hansmi/prometheus-lvm-exporter"
if [[ -n "${MY_PV_HASH}" ]]; then
	MY_PV=${MY_PV_HASH}
	MYSQLD_EXPORTER_COMMIT=${MY_PV_HASH:0:8}
	SRC_URI_UPSTREAM="${HOMEPAGE}/archive/${MY_PV}.tar.gz"
else
	MY_PV=${PV}
	MYSQLD_EXPORTER_COMMIT=
	SRC_URI_UPSTREAM="${HOMEPAGE}/archive/refs/tags/v${PV}.tar.gz"
fi
MY_P=${PN}-${MY_PV}
SRC_URI_VENDOR="https://dev.gentoo.org/~robbat2/distfiles/${MY_P}-vendor.tar.xz"

DESCRIPTION="Prometheus exporter for LVM metrics"
SRC_URI="
	${SRC_URI_UPSTREAM} -> ${P}.tar.gz
	${SRC_URI_VENDOR}
	"

LICENSE="Apache-2.0 BSD MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
BDEPEND=""
DEPEND=""
# lvm is explicitly not included here; this could be installed before it safely.
RDEPEND=""
S="${WORKDIR}/${PN}-${MY_PV}"

PATCHES=( )

src_prepare() {
	default
	sed -i -e '/kingpin.Flag.*\<command\>.*/s,/usr/sbin/lvm,/sbin/lvm,g' "${S}"/main.go || die
}

src_compile() {
	default
	go build .
}

src_install() {
	default
	dobin ${PN}
	dodoc README.md

	# TODO: more secure config would be a dedicated user AND a sudo command, so
	# the daemon can run 'sudo lvm ...'.
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}

src_test() {
	go test .
}
