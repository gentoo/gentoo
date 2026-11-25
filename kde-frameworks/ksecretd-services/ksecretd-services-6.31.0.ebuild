# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# this is purely for service file creation
ECM_I18N="false"
ECM_HANDBOOK="false"
KDE_ORG_NAME="kwallet"
inherit ecm-common frameworks.kde.org

DESCRIPTION="D-Bus service files for ksecretd kwallet runtime component"

LICENSE="LGPL-2+"
SLOT="6"
KEYWORDS="amd64 arm64 ~loong ppc64 ~riscv ~x86"
IUSE="systemd"

RDEPEND="!<kde-frameworks/kwallet-runtime-6.18.0-r1:6"

ecm-common_inject_heredoc() {
	my_configure_file(){
		echo "configure_file(src/runtime/ksecretd/${1}.in \${CMAKE_CURRENT_BINARY_DIR}/${1})"
	}

	cat >> CMakeLists.txt <<- _EOF_ || die
		option(WITH_SYSTEMD "Install service file for portal DBus service" ON) # KDE-bug #509680
		$(my_configure_file org.kde.secretservicecompat.service)
		if(WITH_SYSTEMD)
			$(my_configure_file org.freedesktop.impl.portal.desktop.kwallet.service)
		endif()
		install(FILES
				\${CMAKE_CURRENT_BINARY_DIR}/org.kde.secretservicecompat.service
			DESTINATION \${KDE_INSTALL_DBUSSERVICEDIR}
		)
		if(WITH_SYSTEMD)
			install(FILES
					\${CMAKE_CURRENT_BINARY_DIR}/org.freedesktop.impl.portal.desktop.kwallet.service
				DESTINATION \${KDE_INSTALL_DBUSSERVICEDIR}
			)
		endif()
	_EOF_
}

src_prepare() {
	ecm-common_src_prepare

	# Safety measure in case new services are added in the future
	local known_num_of_services=2
	local found_num_of_services=$(find src/runtime/ksecretd -iname "*service.in" | wc -l)
	if [[ ${found_num_of_services} != ${known_num_of_services} ]]; then
		eerror "Number of service files mismatch!"
		eerror "Expected: ${known_num_of_services}"
		eerror "Found: ${found_num_of_services}"
		die
	fi
}

src_configure() {
	local mycmakeargs=( -DWITH_SYSTEMD=$(usex systemd) )
	ecm-common_src_configure
}
