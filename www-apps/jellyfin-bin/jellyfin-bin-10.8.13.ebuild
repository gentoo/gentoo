# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit pax-utils systemd tmpfiles

DESCRIPTION="Jellyfin puts you in control of managing and streaming your media"
HOMEPAGE="https://jellyfin.readthedocs.io/en/latest/
	https://github.com/jellyfin/jellyfin/"

SRC_URI="
	arm64? (
		https://repo.jellyfin.org/releases/server/linux/versions/stable/combined/${PV}/jellyfin_${PV}_arm64.tar.gz
		https://repo.jellyfin.org/archive/linux/stable/${PV}/combined/jellyfin_${PV}_arm64.tar.gz
	)
	amd64? (
		https://repo.jellyfin.org/releases/server/linux/versions/stable/combined/${PV}/jellyfin_${PV}_amd64.tar.gz
		https://repo.jellyfin.org/archive/linux/stable/${PV}/combined/jellyfin_${PV}_amd64.tar.gz
	)"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64"
RESTRICT="mirror test"
REQUIRED_USE="elibc_glibc"

DEPEND="acct-user/jellyfin
	media-libs/fontconfig
	sys-libs/zlib"
RDEPEND="${DEPEND}
	dev-libs/icu
	media-video/ffmpeg[vpx,x264]"
BDEPEND="acct-user/jellyfin"

INST_DIR="/opt/jellyfin"
QA_PREBUILT="${INST_DIR#/}/*.so ${INST_DIR#/}/jellyfin ${INST_DIR#/}/createdump"

src_unpack() {
	unpack ${A}
	mv jellyfin_${PV} ${P} || die
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
	newtmpfiles - jellyfin.conf <<<"d /var/cache/jellyfin 0775 jellyfin jellyfin -"
	chmod 755 "${D}${INST_DIR}/jellyfin"
	newinitd "${FILESDIR}/jellyfin.init-r1" "jellyfin"
	newconfd "${FILESDIR}"/jellyfin.confd "jellyfin"
	systemd_dounit "${FILESDIR}/jellyfin.service"
	pax-mark -m "${ED}${INST_DIR}/jellyfin"
}

pkg_postinst() {
	tmpfiles_process jellyfin.conf
}
