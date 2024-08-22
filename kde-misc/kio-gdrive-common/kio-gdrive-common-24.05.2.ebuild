# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="true"
KDE_ORG_CATEGORY="network"
KDE_ORG_NAME="${PN/-common/}"
KF5_BDEPEND=( "kde-apps/kaccounts-integration:5" )
KF6_BDEPEND=( "kde-apps/kaccounts-integration:6" )
KFMIN=5.115.0
inherit ecm-common gear.kde.org

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	!<kde-misc/kio-gdrive-23.08.5-r2:5
	!<kde-misc/kio-gdrive-24.05.2-r1:6
"

ECM_INSTALL_FILES=(
	desktop/gdrive-network.desktop:\${KDE_INSTALL_DATADIR}/remoteview
	desktop/org.kde.kio_gdrive.metainfo.xml:\${KDE_INSTALL_METAINFODIR}
)

ecm-common-check_deps() {
	return $(has_version -b "kde-apps/kaccounts-integration:6")
}

ecm-common_inject_heredoc() {
	cat >> CMakeLists.txt <<- _EOF_ || die
		if(KFSLOT STREQUAL "6")
			find_package(KAccounts6 REQUIRED)
		else()
			find_package(KAccounts REQUIRED)
		endif()

		kaccounts_add_service(\${CMAKE_CURRENT_SOURCE_DIR}/kaccounts/google-drive.service.in)
	_EOF_
}

src_prepare() {
	ecm-common_src_prepare

	# Safety measure in case new services are added in the future
	local known_num_of_services=1
	local found_num_of_services=$(find . -iname "*service.in" | wc -l)
	if [[ ${found_num_of_services} != ${known_num_of_services} ]]; then
		eerror "Number of service files mismatch!"
		eerror "Expected: ${known_num_of_services}"
		eerror "Found: ${found_num_of_services}"
		die
	fi
}
