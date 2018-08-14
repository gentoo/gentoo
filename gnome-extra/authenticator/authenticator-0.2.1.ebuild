# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5,6} )
inherit gnome2-utils meson python-r1 virtualx xdg-utils

DESCRIPTION="Two-factor authentication code generator for GNOME"
HOMEPAGE="https://github.com/bilelmoussaoui/Authenticator"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	SRC_URI=""
	EGIT_REPO_URI="${HOMEPAGE}"
else
	SRC_URI="https://github.com/bilelmoussaoui/Authenticator/archive/${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/Authenticator-${PV}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"

DEPEND="
	app-crypt/libsecret
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/pyotp[${PYTHON_USEDEP}]
	dev-python/pyzbar[${PYTHON_USEDEP}]
	media-gfx/gnome-screenshot
	x11-libs/gtk+:3
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/disable-failing-tests.patch" )

pkg_preinst() {
	gnome2_icon_savelist
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	gnome2_schemas_update
}

src_test() {
	xdg_environment_reset
	virtx meson_src_test
}
