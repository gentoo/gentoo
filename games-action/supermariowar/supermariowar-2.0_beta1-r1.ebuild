# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

MY_PV=$(ver_rs 2 '-')
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
	dev-cpp/yaml-cpp
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-image[png,jpeg]
	net-libs/enet:1.3=
	sys-libs/zlib:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/unzip
	virtual/pkgconfig
"

S="${WORKDIR}/${PN}-${MY_PV}"

PATCHES=( "${FILESDIR}"/${P}-cmake-add_library-static.patch )

src_unpack() {
	default
	pushd "${S}" || die
	unpack ./data.zip
	cp "${FILESDIR}"/${P}-yaml-cpp-config.cmake cmake/Findyaml-cpp.cmake || die
	popd || die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_STATIC_LIBS=OFF
		-DSMW_BINDIR="${EPREFIX}"/usr/bin
		-DSMW_DATADIR="${EPREFIX}"/usr/share/${PF}
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	local bin
	for bin in "${ED}"/usr/bin/*; do
		chmod 0755 ${bin} || die
	done

	local smw_datadir="usr/share/${PF}"
	local smw_bindir="${smw_datadir}/bin"
	mkdir -p "${ED}"/${smw_bindir} || die

	ebegin "Moving ${PN} binary files to /${smw_bindir}"
	mv "${ED}"/usr/bin/* "${ED}"/${smw_bindir} || die
	eend $?

	local base_bin
	for bin in "${ED}"/${smw_bindir}/*; do
		base_bin=$(basename ${bin})
		ebegin "Creating ${base_bin} launcher in /usr/bin"
		cat << EOF > ${base_bin} || die
#!/usr/bin/env bash
# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# ${PF} launcher: ${base_bin}
exec /${smw_bindir}/${base_bin} /${smw_datadir}
EOF
		dobin ${base_bin}
		eend $?
	done

	if use server; then
		local smw_server="${BUILD_DIR}"/Binaries/Release/${MY_PN}-server
		local smw_serverdir="/${smw_datadir}/server"

		ebegin "Installing ${MY_PN}-server files"
		dosbin "${smw_server}"

		dodir ${smw_serverdir}
		insinto ${smw_serverdir}
		doins "${S}"/src/server/serverconfig

		dosym ${smw_serverdir}/serverconfig /etc/${MY_PN}d.conf

		newinitd "${FILESDIR}"/smwd.initd ${MY_PN}d
		sed -e "s#@SMW_SERVERDIR@#${smw_serverdir}#g;" \
			-i "${ED}"/etc/init.d/${MY_PN}d || die
		eend $?
	fi
}
