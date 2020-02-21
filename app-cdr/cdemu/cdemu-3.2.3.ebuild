# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit bash-completion-r1 cmake-utils python-single-r1 xdg-utils

MY_P=cdemu-client-${PV}
DESCRIPTION="Command-line tool for controlling cdemu-daemon"
HOMEPAGE="https://cdemu.sourceforge.io"
SRC_URI="https://download.sourceforge.net/cdemu/cdemu-client/${MY_P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+cdemu-daemon"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/pygobject:3[${PYTHON_MULTI_USEDEP}]
	')
	cdemu-daemon? ( app-cdr/cdemu-daemon:0/7 )"
DEPEND="
	dev-util/desktop-file-utils
	>=dev-util/intltool-0.21
	>=sys-devel/gettext-0.18
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

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
