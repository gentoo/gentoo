# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module
# uncomment the first setting of MY_PV for a normal release
# MY_PV="v${PV/_rc/-rc.}"
# set MY_PV to the full commit hash for a snapshot release
MY_PV_HASH=ae39c6be10364896683ab1af0512ee8453bc153e
HOMEPAGE="https://github.com/projg2/portage-exporter"
if [[ -n "${MY_PV_HASH}" ]]; then
	MY_PV=${MY_PV_HASH}
	EXPORTER_COMMIT=${MY_PV_HASH:0:8}
	SRC_URI_UPSTREAM="${HOMEPAGE}/archive/${MY_PV}.tar.gz"
else
	MY_PV=${PV}
	EXPORTER_COMMIT=
	SRC_URI_UPSTREAM="${HOMEPAGE}/archive/refs/tags/v${PV}.tar.gz"
fi
MY_P=${PN}-${MY_PV}
SRC_URI_VENDOR="https://dev.gentoo.org/~robbat2/distfiles/${MY_P}-vendor.tar.xz"
#SRC_URI_VENDOR="https://dev.gentoo.org/~robbat2/distfiles/${MY_P}-go-mod.tar.xz"

DESCRIPTION="Prometheus exporter for Gentoo Portage"
SRC_URI="
	${SRC_URI_UPSTREAM} -> ${P}.tar.gz
	${SRC_URI_VENDOR}
	"

LICENSE="Apache-2.0 BSD MIT GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
BDEPEND=""
DEPEND=""
RDEPEND=""
S="${WORKDIR}/${PN}-${MY_PV}"

PATCHES=( )

src_compile() {
	#cd ./cmd/portage-exporter/
	#ego build
	ego build -o "${PN}" ./cmd/portage-exporter/
}

src_install() {
	dobin ${PN}

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
