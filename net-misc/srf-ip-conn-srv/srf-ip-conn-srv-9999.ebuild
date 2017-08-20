# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vcs-snapshot git-r3 cmake-utils

DESCRIPTION="SharkRF IP Connector Protocol server"
HOMEPAGE="https://github.com/sharkrf/srf-ip-conn-srv"
srfipcon="srf-ip-conn-140c9b8a8619"
jsmn="jsmn-35086597a72d"
SRC_URI="https://github.com/sharkrf/srf-ip-conn/archive/140c9b8a86193b8f345c9e113691113310859ff8.tar.gz -> ${srfipcon}.tar.gz
		https://github.com/zserge/jsmn/archive/35086597a72d94d8393e6a90b96e553d714085bd.tar.gz -> ${jsmn}.tar.gz"
EGIT_REPO_URI="https://github.com/sharkrf/srf-ip-conn-srv.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}/build"

CMAKE_IN_SOURCE_BUILD=true

src_unpack() {
	vcs-snapshot_src_unpack ${A}
	git-r3_src_unpack
}

src_prepare() {
	#set needed paths
	sed -i "s#\$ENV{JSMN_PATH}#${WORKDIR}/${jsmn}#" CMakeLists.txt
	sed -i "s#\$ENV{SRF_IP_CONN_PATH}#${WORKDIR}/${srfipcon}#" CMakeLists.txt

	#set cflags/ldflags
	sed -i "s#-O4#${CFLAGS}#" CMakeLists.txt
	sed -i "s#CMAKE_EXE_LINKER_FLAGS_RELEASE \"\"#CMAKE_EXE_LINKER_FLAGS_RELEASE \"${LDFLAGS}\"#" CMakeLists.txt

	#be in a sane directory for eapply_user
	cd "${WORKDIR}/${P}"
	eapply_user
}

src_install() {
	#add a default banned list to edit
	sed -i 's#"banlist-file": ""#"banlist-file":"/etc/srf-ip-conn-srv/banlist.json"#' "${WORKDIR}/${P}/config-example.json"
	echo "{}" > "${ED}/etc/srf-ip-conn-srv/banlist.json"

	insinto /etc/srf-ip-conn-srv
	doins "${WORKDIR}/${P}/banlist-example.json"
	newins "${WORKDIR}/${P}/config-example.json" config.json
	newbin Release/srf-ip-conn-srv srf-ip-conn-srv-target

	dobin "${FILESDIR}/srf-ip-conn-srv"
}
