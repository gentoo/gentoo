# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GNOME_ORG_MODULE="sysprof"

inherit gnome.org meson multilib-minimal systemd

DESCRIPTION="Static library for sysprof capture data generation"
HOMEPAGE="http://sysprof.com/"

LICENSE="GPL-3+ GPL-2+"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.61.3:2
	!=dev-util/sysprof-3.34.1-r0"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/gdbus-codegen
	>=sys-kernel/linux-headers-2.6.32
	virtual/pkgconfig
"

multilib_src_configure() {
	local emesonargs=(
		-Denable_gtk=false
		-Dlibsysprof=false
		-Dwith_sysprofd=none
		-Dsystemdunitdir=$(systemd_get_systemunitdir)
		# -Ddebugdir
		-Dhelp=false
		-Dlibunwind=false
	)
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_test() {
	meson_src_test
}

multilib_src_install() {
	meson_src_install
}
