# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GNOME_ORG_MODULE="sysprof"

inherit dot-a gnome.org meson-multilib systemd

DESCRIPTION="Static library for sysprof capture data generation"
HOMEPAGE="https://www.sysprof.com/"

LICENSE="GPL-3+ GPL-2+"
SLOT="4"
KEYWORDS="amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"

# RDEPEND=""
# DEPEND=""
BDEPEND="
	dev-util/gdbus-codegen
	>=sys-kernel/linux-headers-2.6.32
	virtual/pkgconfig
"

src_configure() {
	lto-guarantee-fat
	meson-multilib_src_configure
}

multilib_src_configure() {
	local emesonargs=(
		-Dgtk=false
		-Dlibsysprof=false
		-Dinstall-static=true
		-Dsysprofd=none
		-Dsystemdunitdir=$(systemd_get_systemunitdir)
		# -Ddebugdir
		-Dhelp=false
		-Dtools=false
		-Dtests=false
		-Dexamples=false
	)
	meson_src_configure
}

multilib_src_install_all() {
	einstalldocs
	strip-lto-bytecode
}
