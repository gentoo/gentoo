# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-utils-2 systemd tmpfiles

MY_PN=${PN%-bin}
MY_P=${MY_PN}-${PV}

DESCRIPTION="An autosuspend and wakeup daemon"
HOMEPAGE="https://gitlab.gentoo.org/flow/sandmann"
SRC_URI="https://dev.gentoo.org/~flow/${MY_PN}/archive/${MY_P}.tar.xz"
KEYWORDS="amd64"

LICENSE="GPL-3+ LGPL-3"
SLOT="0"

# >=java-config-2.3.2 to get the libdir fix.
RDEPEND="
	acct-user/sandmann
	>=dev-java/java-config-2.3.2
	sys-apps/systemd
	sys-auth/polkit
	|| (
		virtual/jre:17
		virtual/jre:21
	)
"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	sed -i \
		-e 's|^ExecStart=.*|ExecStart=/usr/bin/sandmann|' \
		sandmann.service || die
}

src_compile() {
	:
}

src_install() {
	local my_emake_args=(
		DESTDIR="${D}"
		SYSTEMD_SYSTEM_UNIT_DIR="$(systemd_get_systemunitdir)"
		TARGET_BINARY=
		SOURCELESS_INSTALL=true
	)

	emake ${my_emake_args[@]} install

	java-pkg_newjar out/main/assembly.dest/out.jar sandmann.jar
	java-pkg_dolauncher sandmann

	dodoc README.md
}

pkg_postinst() {
	tmpfiles_process sandmann.conf
}
