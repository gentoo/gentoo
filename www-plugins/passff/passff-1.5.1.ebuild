# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit mozextension

DESCRIPTION="zx2c4 pass manager extension for Firefox"
HOMEPAGE="https://github.com/passff/passff"
SRC_URI="https://addons.mozilla.org/firefox/downloads/file/1056515/passff-1.5.1-an+fx-linux.xpi"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="firefox firefox-bin"

RDEPEND="www-plugins/passff-host[firefox]"
REQUIRED_USE="|| ( firefox firefox-bin )"

S="${WORKDIR}"

MY_XPINAME="passff-1.5.1-an+fx-linux"

src_unpack() {
	xpi_unpack "${MY_XPINAME}.xpi"
}

src_install() {
	local MOZILLA_FIVE_HOME
	if use firefox; then
		MOZILLA_FIVE_HOME="/usr/$(get_libdir)/firefox"
		xpi_install "${MY_XPINAME}"
	fi

	if use firefox-bin; then
		MOZILLA_FIVE_HOME="/opt/firefox"
		xpi_install "${MY_XPINAME}"
	fi
}
