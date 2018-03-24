# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{4,5,6}} )

inherit bash-completion-r1 cmake-utils python-single-r1 xdg-utils

DESCRIPTION="Command-line tool for controlling cdemu-daemon"
HOMEPAGE="http://cdemu.org"
SRC_URI="mirror://sourceforge/cdemu/cdemu-client-${PV}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~hppa x86"
IUSE="+cdemu-daemon"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	cdemu-daemon? ( app-cdr/cdemu-daemon:0/7 )"
DEPEND="${RDEPEND}
	dev-util/desktop-file-utils
	>=dev-util/intltool-0.21
	>=sys-devel/gettext-0.18"

S=${WORKDIR}/cdemu-client-${PV}

PATCHES=( "${FILESDIR}/${PN}-3.0.0-bash-completion-dir.patch" )

src_prepare() {
	cmake-utils_src_prepare

	python_fix_shebang src/cdemu
}

src_configure() {
	local DOCS=( AUTHORS README )
	local mycmakeargs=(
		-DPOST_INSTALL_HOOKS=OFF
		-DGENTOO_BASHCOMPDIR="$(get_bashcompdir)"
	)
	cmake-utils_src_configure
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
