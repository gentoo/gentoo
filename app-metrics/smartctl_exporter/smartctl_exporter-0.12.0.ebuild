# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module systemd

DESCRIPTION="Export smartctl statistics to prometheus"
HOMEPAGE="https://github.com/prometheus-community/smartctl_exporter"

# uncomment the first setting of MY_PV for a normal release
# MY_PV="v${PV/_rc/-rc.}"
# set MY_PV to the full commit hash for a snapshot release
MY_PV_HASH=
: ${MY_PV_HASH_FOR_VENDOR:=${MY_PV_HASH}}
if [[ -n "${MY_PV_HASH}" ]]; then
	MY_PV=${MY_PV_HASH}
	SMARTCTL_EXPORTER_COMMIT=${MY_PV_HASH:0:8}
	SRC_URI_UPSTREAM="${HOMEPAGE}/archive/${MY_PV}.tar.gz"
else
	MY_PV=$PV
	SMARTCTL_EXPORTER_COMMIT=
	SRC_URI_UPSTREAM="${HOMEPAGE}/archive/refs/tags/v${PV}.tar.gz"
fi
MY_P=${PN}-${MY_PV}
SRC_URI_VENDOR="https://dev.gentoo.org/~robbat2/distfiles/${MY_P}-vendor.tar.xz"
SRC_URI="
	${SRC_URI_UPSTREAM} -> ${P}.tar.gz
	${SRC_URI_VENDOR}
	"

# Upstream LICENSE file is wrong see https://github.com/prometheus-community/smartctl_exporter/pull/113
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
BDEPEND="dev-util/promu"
DEPEND="dev-lang/go"
RDEPEND="sys-apps/smartmontools"

src_prepare() {
	default
	if [[ -n $SMARTCTL_EXPORTER_COMMIT ]]; then
		sed -i -e "s/{{.Revision}}/${SMARTCTL_EXPORTER_COMMIT}/" .promu.yml || die
	fi
}

src_compile() {
	emake build PROMU='/usr/bin/promu'
}

src_install() {
	dodoc *.md
	dobin ${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit "${FILESDIR}/${PN}.service"

}
