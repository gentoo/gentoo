# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info meson systemd udev

DESCRIPTION="FIFO-like jobserver node via CUSE"
HOMEPAGE="https://codeberg.org/amonakov/guildmaster"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://codeberg.org/amonakov/guildmaster.git"
	inherit git-r3
else
	GUILDMASTER_COMMIT="463382ba5b47625a9355832cd792a164c54237f9"
	SRC_URI="https://codeberg.org/amonakov/guildmaster/archive/${GUILDMASTER_COMMIT}.tar.gz -> ${PN}-${GUILDMASTER_COMMIT}.cb.tar.gz"
	S="${WORKDIR}"/${PN}

	KEYWORDS="~amd64"
fi

LICENSE="ISC"
SLOT="0"

DEPEND="sys-fs/fuse:3="
RDEPEND="
	${DEPEND}
"

pkg_pretend() {
	local CONFIG_CHECK="~CUSE"
	check_extra_config
}

src_configure() {
	local emesonargs=(
		-Dopenrc=true
		-Dsystemd=true
		-Dsystemdunitdir="$(systemd_get_systemunitdir)"
		-Dudev=true
		-Dudevrulesdir="$(get_udevdir)"/rules.d
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	insinto /etc/sandbox.d
	newins "${FILESDIR}"/sandbox.conf 90guildmaster
}

pkg_postinst() {
	udev_reload

	if ! grep -q -s -R -- '--jobserver-auth=fifo:/dev/guild' "${EROOT}"/etc/portage/make.conf ; then
		elog "In order to use a system-wide guildmaster instance, enable the service:"
		elog
		elog "  systemctl enable --now guildmaster"
		elog
		elog "Then add to your make.conf:"
		elog
		elog '  MAKEFLAGS="--jobserver-auth=fifo:/dev/guild"'
		elog '  NINJAOPTS=""'
		elog
		elog "You can use -l in NINJAOPTS but *do not* use -j, as it disables"
		elog "jobserver support."
	fi
}
