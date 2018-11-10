# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python3_{4,5,6,7} )

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
DEPEND="
	dev-util/desktop-file-utils
	>=dev-util/intltool-0.21
	>=sys-devel/gettext-0.18
	virtual/pkgconfig"

S=${WORKDIR}/cdemu-client-${PV}

DOCS=( AUTHORS README )

src_prepare() {
	cmake-utils_src_prepare

	python_fix_shebang src/cdemu
}

src_configure() {
	local mycmakeargs=(
		-DPOST_INSTALL_HOOKS=OFF
		-DCMAKE_INSTALL_COMPLETIONSDIR="$(get_bashcompdir)"
	)
	cmake-utils_src_configure
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
