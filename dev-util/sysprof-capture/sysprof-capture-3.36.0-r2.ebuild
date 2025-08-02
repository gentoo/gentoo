# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GNOME_ORG_MODULE="sysprof"

inherit dot-a gnome.org meson-multilib systemd

DESCRIPTION="Static library for sysprof capture data generation"
HOMEPAGE="https://www.sysprof.com/"

LICENSE="GPL-3+ GPL-2+"
SLOT="3"
KEYWORDS="amd64 ~arm64 ~loong x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.61.3:2[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
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

multilib_src_install_all() {
	einstalldocs
	strip-lto-bytecode
}
