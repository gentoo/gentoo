# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit pax-utils systemd tmpfiles eapi9-ver

DESCRIPTION="Jellyfin puts you in control of managing and streaming your media"
HOMEPAGE="https://jellyfin.org/
	https://github.com/jellyfin/jellyfin/"
MY_PV="${PV//_rc/-rc}"
MINOR_VER=$(ver_cut 1-2)
if [[ ${PV} == *rc* ]]; then
	MY_TYPE="preview"
else
	MY_TYPE="stable"
	KEYWORDS="-* ~amd64 ~arm64"
fi
SRC_URI="
	arm64? (
		elibc_glibc? (
			https://repo.jellyfin.org/files/server/linux/${MY_TYPE}/v${MY_PV}/arm64/jellyfin_${MY_PV}-arm64.tar.xz
		)
		elibc_musl? (
			https://repo.jellyfin.org/files/server/linux/${MY_TYPE}/v${MY_PV}/arm64-musl/jellyfin_${MY_PV}-arm64-musl.tar.xz
		)
	)
	amd64? (
		elibc_glibc? (
			https://repo.jellyfin.org/files/server/linux/${MY_TYPE}/v${MY_PV}/amd64/jellyfin_${MY_PV}-amd64.tar.xz
		)
		elibc_musl? (
			https://repo.jellyfin.org/files/server/linux/${MY_TYPE}/v${MY_PV}/amd64-musl/jellyfin_${MY_PV}-amd64-musl.tar.xz
		)
	)"

LICENSE="GPL-2"
SLOT="0"
RESTRICT="mirror test"

DEPEND="acct-user/jellyfin
	media-libs/fontconfig
	virtual/zlib:="
RDEPEND="${DEPEND}
	dev-libs/icu
	media-video/ffmpeg[vpx,x264]"
BDEPEND="acct-user/jellyfin"

INST_DIR="/opt/jellyfin"
QA_PREBUILT="${INST_DIR#/}/*.so ${INST_DIR#/}/*.so.* ${INST_DIR#/}/jellyfin ${INST_DIR#/}/createdump"

src_unpack() {
	unpack ${A}
	mv jellyfin ${P} || die
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

pkg_preinst() {
	if ver_replacing -gt $MINOR_VER.99; then
		eerror "Downgrading jellyfin from one minor version to a previous one is not supported."
		eerror "If you wish to downgrade you must uninstall jellyfin-bin, restore the database"
		eerror "from a backup and then reinstall jellyfin-bin."
		die "Downgrade path not supported"
	fi
}

pkg_postinst() {
	tmpfiles_process jellyfin.conf

	if ver_replacing -lt $MINOR_VER; then
		ewarn "Jellyfin usually makes backward incompatible database changes in new minor"
		ewarn "releases. At first startup after an upgrade jellyfin will start a database"
		ewarn "migration. This may take a long time but must not be aborted or the database"
		ewarn "could be left in an inconsistant state and must be recreated or restored from"
		ewarn "backup. Once the migration has started it is no longer possible to downgrade"
		ewarn "jellyfin without restoring the database from a backup."
		ewarn ""
		ewarn "The migration progress can be followed in the startup UI in the web browser"
		ewarn "or in the jellyfin logs."
	fi
}
