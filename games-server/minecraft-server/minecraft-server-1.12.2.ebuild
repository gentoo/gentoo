# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit user

DESCRIPTION="The official server for the sandbox video game Minecraft"
HOMEPAGE="https://www.minecraft.net/"
SRC_URI="https://s3.amazonaws.com/Minecraft.Download/versions/${PV}/minecraft_server.${PV}.jar -> ${P}.jar"

LICENSE="Mojang"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="app-misc/screen
	virtual/jre"

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

src_install() {
	insinto /usr/share/games/minecraft-server
	insopts -o minecraft -g minecraft
	newins minecraft-server-${PV}.jar minecraft-server.jar

	newinitd "${FILESDIR}"/minecraft-server.initd minecraft-server
	newconfd "${FILESDIR}"/minecraft-server.confd minecraft-server

	diropts -o minecraft -g minecraft
	keepdir /var/lib/minecraft-server
	keepdir /var/log/minecraft-server
}

pkg_postinst() {
	elog "This package provides an init script and a conf file."
	elog "You don't have to modify those files directly,"
	elog "but instead you can make a symlink of that init script"
	elog "and a copy of that conf file."
	elog "You would do this for every server, you want to setup."
	elog ""
	elog "For example, you wan't to setup an world called 'gentoo',"
	elog "you would do:"
	elog ""
	elog "cd /etc/init.d"
	elog "ln -s minecraft-server minecraft-server.gentoo"
	elog ""
	elog "cd /etc/conf.d"
	elog "cp minecraft-server minecraft-server.gentoo"
	elog ""
	elog "After that, make your settings in"
	elog "/etc/conf.d/minecraft-server.gentoo."
	elog ""
	elog "If you don't make a symlink, but use the default scripts,"
	elog "your world will be called 'main'"
}
