# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PV="808be3869e2ca6b62378f9f4b33c946621620019"

inherit readme.gentoo-r1 java-pkg-2 user

DESCRIPTION="The official server for the sandbox video game"
HOMEPAGE="https://www.minecraft.net/"
SRC_URI="https://launcher.mojang.com/v1/objects/${MY_PV}/server.jar -> ${P}.jar"

LICENSE="Mojang"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	app-misc/screen
	>=virtual/jre-1.8
"

RESTRICT="bindist mirror strip"

S="${WORKDIR}"

pkg_setup() {
	enewgroup minecraft
	enewuser minecraft -1 -1 /var/lib/minecraft-server minecraft
}

src_unpack() {
	# Don't unpack that jar, just copy it to WORKDIR
	cp "${DISTDIR}"/${A} "${WORKDIR}" || die
}

src_compile() {
	:;
}

src_install() {
	java-pkg_newjar minecraft-server-${PV}.jar minecraft-server.jar
	java-pkg_dolauncher minecraft-server --jar minecraft-server.jar --java_args "\${JAVA_OPTS}"

	newinitd "${FILESDIR}"/minecraft-server.initd-r2 minecraft-server
	newconfd "${FILESDIR}"/minecraft-server.confd minecraft-server

	diropts -o minecraft -g minecraft
	keepdir /var/lib/minecraft-server
	keepdir /var/log/minecraft-server

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
