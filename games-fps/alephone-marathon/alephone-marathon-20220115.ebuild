# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

DESCRIPTION="Aleph One - Marathon (M1A1)"
HOMEPAGE="http://marathon.sourceforge.net/"
SRC_URI="https://github.com/Aleph-One-Marathon/alephone/releases/download/release-${PV}/Marathon-${PV}-Data.zip"
S="${WORKDIR}/Marathon"

LICENSE="bungie-marathon"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"

RDEPEND="games-fps/alephone"
BDEPEND="app-arch/unzip"

MY_NAME="marathon"
MY_DIR="/usr/share/alephone-${MY_NAME}"

src_install() {
	insinto "${MY_DIR}"
	doins -r *

	make_desktop_entry "alephone.sh ${MY_NAME}" "${DESCRIPTION}"

	# Make sure the extra dirs exist in case the user wants to add some data
	keepdir "${MY_DIR}"/{Scripts,"Physics Models",Textures,Themes}
}

pkg_postinst() {
	elog "To play this scenario, run:"
	elog "alephone.sh ${MY_NAME}"
}
