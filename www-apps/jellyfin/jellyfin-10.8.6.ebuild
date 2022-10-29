# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="Jellyfin puts you in control of managing and streaming your media"
HOMEPAGE="https://jellyfin.readthedocs.io/en/latest/"

SRC_URI="
	arm64? (
		https://repo.jellyfin.org/releases/server/linux/versions/stable/combined/${PV}/${PN}_${PV}_arm64.tar.gz
		https://repo.jellyfin.org/archive/linux/stable/${PV}/combined/${PN}_${PV}_arm64.tar.gz
	)
	amd64? (
		https://repo.jellyfin.org/releases/server/linux/versions/stable/combined/${PV}/${PN}_${PV}_amd64.tar.gz
		https://repo.jellyfin.org/archive/linux/stable/${PV}/combined/${PN}_${PV}_amd64.tar.gz
	)"

RESTRICT="mirror test"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64"
DEPEND="acct-user/jellyfin"
RDEPEND="${DEPEND}
	dev-libs/icu
	media-video/ffmpeg[vpx,x264]
	sys-libs/glibc"
BDEPEND="acct-user/jellyfin"
INST_DIR="/opt/${PN}"
QA_PREBUILT="${INST_DIR#/}/*.so ${INST_DIR#/}/jellyfin ${INST_DIR#/}/createdump"

src_unpack() {
	unpack ${A}
	mv ${PN}_${PV} ${P} || die
}

src_prepare() {
	default

	# https://github.com/jellyfin/jellyfin/issues/7471
	# https://github.com/dotnet/runtime/issues/57784
	rm libcoreclrtraceptprovider.so || die
}

src_install() {
	keepdir /var/log/jellyfin
	fowners jellyfin:jellyfin /var/log/jellyfin
	keepdir /etc/jellyfin
	fowners jellyfin:jellyfin /etc/jellyfin
	insinto ${INST_DIR}
	dodir ${INST_DIR}
	doins -r "${S}"/*
	chmod 755 "${D}${INST_DIR}/jellyfin"
	newinitd "${FILESDIR}/${PN}.init-r1" "${PN}"
	newconfd "${FILESDIR}"/${PN}.confd "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"
}
