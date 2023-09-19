# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit udev

# Although this is mainly a tweaked version of Steam's udev rules, it
# also has its own rules and more may be added later so we version it
# independently.

STEAM_COMMIT="d87ef558408c5e7a1a793d738db4c9dc2cb5f8fa"
MY_P="steam-devices-${STEAM_COMMIT}"

DESCRIPTION="udev rules for various game hardware devices"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Games"
SRC_URI="https://github.com/ValveSoftware/steam-devices/archive/${STEAM_COMMIT}.tar.gz -> ${MY_P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+acl elogind systemd"
REQUIRED_USE="acl? ( || ( elogind systemd ) )"

RDEPEND="
	acl? (
		elogind? ( sys-auth/elogind[acl] )
		systemd? ( sys-apps/systemd[acl] )
	)
	!acl? (
		acct-group/input
	)
	virtual/udev
"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if ! use acl; then
		elog "Users of game hardware devices must be added to the input group."

		if use elogind || use systemd; then
			ewarn "It is highly recommended that you enable USE=acl on this package instead"
			ewarn "when using elogind or systemd as this is more secure and just works."
		fi
	fi
}

src_prepare() {
	default

	local SRC DEST EXTRA
	for SRC in 60-steam-{input,vr}.rules; do
		DEST=${SRC//steam/game}
		EXTRA=${FILESDIR}/${DEST/./-"${PV}".}

		# Make changes in a copy.
		cp -v "${SRC}" "${DEST}" || die

		# Append our additional rules.
		if [[ -f ${EXTRA} ]]; then
			cat "${EXTRA}" >> "${DEST}" || die
		fi

		# Clear any existing mode settings.
		sed -i 's/, *MODE="[0-9]*"//' "${DEST}" || die

		if ! use acl; then
			# Replace uaccess tag with our group+mode if not using ACL.
			sed -i 's/, *TAG+="uaccess"/, GROUP="input", MODE="0660"/' "${DEST}" || die
		fi
	done
}

src_install() {
	udev_dorules 60-game-{input,vr}.rules
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
