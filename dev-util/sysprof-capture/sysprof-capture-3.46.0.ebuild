# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GNOME_ORG_MODULE="sysprof"

inherit gnome.org meson-multilib systemd

DESCRIPTION="Static library for sysprof capture data generation"
HOMEPAGE="http://sysprof.com/"

LICENSE="GPL-3+ GPL-2+"
SLOT="4"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND=""
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/gdbus-codegen
	>=sys-kernel/linux-headers-2.6.32
	virtual/pkgconfig
"

multilib_src_configure() {
	local emesonargs=(
		-Dgtk=false
		-Dlibsysprof=false
		-Dinstall-static=true
		-Dsysprofd=none
		-Dsystemdunitdir=$(systemd_get_systemunitdir)
		# -Ddebugdir
		-Dhelp=false
		-Dlibunwind=false
		-Dtools=false
		-Dtests=false
		-Dexamples=false
		-Dagent=false
	)
	meson_src_configure
}
