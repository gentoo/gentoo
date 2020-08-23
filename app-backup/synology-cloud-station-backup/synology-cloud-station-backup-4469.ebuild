# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit xdg

SVER="4.3.3"

DESCRIPTION="Back up your files from multiple client computers to a centralized Synology NAS"
HOMEPAGE="https://www.synology.com/en-global/releaseNote/CloudStationBackup"
SRC_URI="
	amd64? ( https://global.download.synology.com/download/Tools/CloudStationBackup/${SVER}-${PV}/Ubuntu/Installer/x86_64/synology-cloud-station-backup-${PV}.x86_64.deb )
	x86? ( https://global.download.synology.com/download/Tools/CloudStationBackup/${SVER}-${PV}/Ubuntu/Installer/i686/synology-cloud-station-backup-${PV}.i686.deb )
"

LICENSE="Synology"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

RESTRICT="bindist mirror strip"
QA_PREBUILT="*"

S="${WORKDIR}"

src_unpack() {
	default
	unpack "${WORKDIR}"/data.tar.xz

	# Allow provided docs are useless
	rm -r usr/share/doc || die
}

src_install() {
	insinto /
	doins -r opt/
	doins -r usr/

	# Fix permissions
	chmod +x "${ED}"/usr/bin/* || die
	chmod +x "${ED}"/opt/Synology/CloudStationBackup/bin/* || die
}
