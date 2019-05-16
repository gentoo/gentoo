# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils git-r3 xdg

MY_PN="CPU-X"
DESCRIPTION="A Free software that gathers information on CPU, motherboard and more"
HOMEPAGE="https://x0rg.github.io/CPU-X https://github.com/X0rg/CPU-X"
EGIT_REPO_URI="https://github.com/X0rg/${MY_PN}.git"
LICENSE="GPL-3+"
SLOT="0"
IUSE="+bandwidth check-update +dmidecode force-libstatgrab +gtk +libcpuid +libpci +ncurses +nls"

DEPEND="
	check-update? (
		dev-libs/json-c:=
		net-misc/curl
	)
	force-libstatgrab? ( sys-libs/libstatgrab )
	!force-libstatgrab? ( sys-process/procps:= )
	gtk? ( >=x11-libs/gtk+-3.12:3 )
	libcpuid? ( >=sys-libs/libcpuid-0.3.0:= )
	libpci? ( sys-apps/pciutils )
	ncurses? ( sys-libs/ncurses:= )
"

BDEPEND="
	dev-lang/nasm
	nls? ( sys-devel/gettext )
"

RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-custom-build-fix.patch"
	"${FILESDIR}/${P}-static-libs-fix.patch"
)

src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DWITH_GTK=$(usex gtk)
		-DWITH_NCURSES=$(usex ncurses)
		-DWITH_GETTEXT=$(usex nls)
		-DWITH_LIBCURL=$(usex check-update)
		-DWITH_LIBJSONC=$(usex check-update)
		-DWITH_LIBCPUID=$(usex libcpuid)
		-DWITH_LIBPCI=$(usex libpci)
		-DWITH_LIBSTATGRAB=OFF
		-DWITH_DMIDECODE=$(usex dmidecode)
		-DWITH_BANDWIDTH=$(usex bandwidth)
		-DFORCE_LIBSTATGRAB=$(usex force-libstatgrab)
	)

	cmake-utils_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst

	ewarn "Please make sure that \`lm_sensors\` is correctly configured."
	ewarn "Otherwise \`cpu-x\` may have some difficulty in obtaining the CPU temperature or voltage."
	ewarn "For more information, see https://wiki.gentoo.org/wiki/Lm_sensors."
}
