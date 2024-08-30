# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# this is purely for service file creation
ECM_I18N="false"
ECM_HANDBOOK="false"
KDE_ORG_NAME="${PN/-kaccounts-services/}"
KF5_BDEPEND=( "|| (
	kde-apps/kaccounts-integration:6[qt5]
	kde-apps/kaccounts-integration:5
)" )
KF6_BDEPEND=( "kde-apps/kaccounts-integration:6" )
KFMIN=5.115.0
inherit ecm-common frameworks.kde.org

DESCRIPTION="KAccounts generated service files for nextcloud and google services"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"
IUSE=""

RDEPEND="
	!<kde-frameworks/purpose-5.116.0-r2:5
	!<kde-frameworks/purpose-6.5.0-r1:6
"

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

		kaccounts_add_service(\${CMAKE_CURRENT_SOURCE_DIR}/src/plugins/nextcloud/nextcloud-upload.service.in)
		kaccounts_add_service(\${CMAKE_CURRENT_SOURCE_DIR}/src/plugins/youtube/google-youtube.service.in)
	_EOF_
}

src_prepare() {
	ecm-common_src_prepare

	# Safety measure in case new services are added in the future
	local known_num_of_services=2
	local found_num_of_services=$(find . -iname "*service.in" | wc -l)
	if [[ ${found_num_of_services} != ${known_num_of_services} ]]; then
		eerror "Number of service files mismatch!"
		eerror "Expected: ${known_num_of_services}"
		eerror "Found: ${found_num_of_services}"
		die
	fi
}
