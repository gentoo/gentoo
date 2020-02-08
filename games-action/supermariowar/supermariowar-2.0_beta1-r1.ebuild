# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils cmake-utils versionator

MY_PV=$(replace_version_separator 2 '-')
MY_PV="${MY_PV/beta1/beta.1}"
MY_PN="smw"

DESCRIPTION="Fan-made multiplayer Super Mario Bros. style deathmatch game"
HOMEPAGE="https://github.com/mmatyas/supermariowar"
SRC_URI="https://github.com/mmatyas/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="server"

RDEPEND="
	sys-libs/zlib:=
	dev-cpp/yaml-cpp
	net-libs/enet:1.3=
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-image[png,jpeg]"

DEPEND="
	${RDEPEND}
	app-arch/unzip
	virtual/pkgconfig"

S="${WORKDIR}/${PN}-${MY_PV}"

src_unpack() {
	unpack ${A}
	cd "${S}" || die
	unpack ./data.zip
}

src_prepare() {
	cmake-utils_src_prepare

	einfo "Copying Findyaml-cpp.cmake"
	cp "${FILESDIR}/${P}-yaml-cpp-config.cmake" cmake/Findyaml-cpp.cmake || die
	eend $?
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_STATIC_LIBS=OFF
		-DSMW_BINDIR="${EPREFIX}/usr/bin"
		-DSMW_DATADIR="${EPREFIX}/usr/share/${PF}"
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	local bin
	for bin in "${ED}/usr/bin"/*; do
		chmod 0755 "${bin}" || die
	done

	local smw_datadir="usr/share/${PF}"
	local smw_bindir="${smw_datadir}/bin"
	mkdir -p "${ED}/${smw_bindir}" || die

	einfo "Moving ${PN} binary files to /${smw_bindir}"
	mv "${ED}/usr/bin"/* "${ED}/${smw_bindir}" || die
	eend $?

	local base_bin
	for bin in "${ED}/${smw_bindir}"/*; do
		base_bin=$(basename "${bin}")
		einfo "Creating ${base_bin} launcher in /usr/bin"
		cat << EOF > "${base_bin}" || die
#!/usr/bin/env bash
# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# ${PF} launcher: ${base_bin}
exec /${smw_bindir}/${base_bin} /${smw_datadir}
EOF
		dobin "${base_bin}"
		eend $?
	done

	if use server; then
		local smw_server="${BUILD_DIR}/Binaries/Release/${MY_PN}-server"
		local smw_serverdir="/${smw_datadir}/server"

		einfo "Installing ${MY_PN}-server files"
		dosbin "${smw_server}"

		dodir "${smw_serverdir}"
		insinto "${smw_serverdir}"
		doins "${S}/src/server/serverconfig"

		dosym "${smw_serverdir}/serverconfig" "/etc/${MY_PN}d.conf"

		newinitd "${FILESDIR}/smwd.initd" "${MY_PN}d"
		sed -i -e \
			"s#@SMW_SERVERDIR@#${smw_serverdir}#g;" \
			"${ED}/etc/init.d/${MY_PN}d" || die
		eend $?
	fi
}
