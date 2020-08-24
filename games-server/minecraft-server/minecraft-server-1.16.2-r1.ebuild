# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_COMMIT="c5f6fb23c3876461d46ec380421e42b289789530"
README_GENTOO_SUFFIX="-r1"

inherit readme.gentoo-r1 java-pkg-2

DESCRIPTION="The official server for the sandbox video game"
HOMEPAGE="https://www.minecraft.net/"
SRC_URI="https://launcher.mojang.com/v1/objects/${EGIT_COMMIT}/server.jar -> ${P}.jar"

LICENSE="Mojang"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	acct-group/minecraft
	acct-user/minecraft
	app-misc/dtach
	|| (
		>=virtual/jre-1.8
		>=virtual/jdk-1.8
	)
"

RESTRICT="bindist mirror"

S="${WORKDIR}"

src_unpack() {
	cp "${DISTDIR}/${A}" "${WORKDIR}" || die
}

src_install() {
	java-pkg_newjar minecraft-server-${PV}.jar minecraft-server.jar
	java-pkg_dolauncher minecraft-server --jar minecraft-server.jar --java_args "\${JAVA_OPTS}"

	newinitd "${FILESDIR}"/minecraft-server.initd-r4 minecraft-server
	newconfd "${FILESDIR}"/minecraft-server.confd-r1 minecraft-server

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
