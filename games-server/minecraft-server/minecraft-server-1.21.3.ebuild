# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_COMMIT="45810d238246d90e811d896f87b14695b7fb6839"
README_GENTOO_SUFFIX="-r1"

inherit readme.gentoo-r1 java-pkg-2 systemd

DESCRIPTION="The official server for the sandbox video game"
HOMEPAGE="https://www.minecraft.net/"
SRC_URI="https://piston-data.mojang.com/v1/objects/${EGIT_COMMIT}/server.jar -> ${P}.jar"
S="${WORKDIR}"

LICENSE="Mojang"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
RESTRICT="bindist mirror"

RDEPEND="
	acct-group/minecraft
	acct-user/minecraft
	app-misc/dtach
	|| (
		dev-java/openjdk:21
		dev-java/openjdk-bin:21
	)
"

src_unpack() {
	cp "${DISTDIR}/${A}" "${WORKDIR}" || die
}

src_compile() {
	:;
}

src_install() {
	newbin "${FILESDIR}"/minecraft-server-bin minecraft-server

	java-pkg_newjar minecraft-server-${PV}.jar minecraft-server.jar

	newinitd "${FILESDIR}"/minecraft-server.initd-r5 minecraft-server
	newconfd "${FILESDIR}"/minecraft-server.confd-r1 minecraft-server
	systemd_newunit "${FILESDIR}"/minecraft-server.service minecraft-server@.service

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
