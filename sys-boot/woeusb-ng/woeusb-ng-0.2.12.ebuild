# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=1
PYTHON_COMPAT=( python3_{10..12} )

inherit desktop distutils-r1 optfeature xdg

MY_PN="WoeUSB-ng"
DESCRIPTION="Create a Windows USB stick installer from an iso image (rewrite of WoeUSB)"
HOMEPAGE="https://github.com/WoeUSB/WoeUSB-ng"
SRC_URI="https://github.com/WoeUSB/WoeUSB-ng/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gui"

RDEPEND="
	!sys-boot/woeusb
	app-arch/p7zip
	sys-apps/util-linux
	sys-block/parted
	sys-boot/grub:2
	sys-fs/dosfstools
	sys-fs/ntfs3g[ntfsprogs]
	$(python_gen_cond_dep '
		dev-python/termcolor[${PYTHON_USEDEP}]
		gui? ( dev-python/wxpython:4.0[${PYTHON_USEDEP}] )
	')
"

PATCHES=(
	"${FILESDIR}"/${P}-fix-pkg-discovery.patch
	"${FILESDIR}"/${P}-skip-postinstall.patch
)

src_prepare() {
	distutils-r1_src_prepare
	python_fix_shebang WoeUSB

	# fix hardcoded org.freedesktop.policykit.exec.path
	sed -i "s|/usr/local/bin|${EPREFIX}/usr/bin|" \
		miscellaneous/com.github.woeusb.woeusb-ng.policy \
		WoeUSB/utils.py || die
}

src_install() {
	distutils-r1_src_install

	if use gui; then
		dobin WoeUSB/woeusbgui

		insinto /usr/share/polkit-1/actions
		doins miscellaneous/com.github.woeusb.woeusb-ng.policy

		doicon -s 256 WoeUSB/data/woeusb-logo.png
		make_desktop_entry woeusbgui WoeUSB-ng woeusb-logo Utility
	fi
}

pkg_postinst() {
	xdg_pkg_postinst
	optfeature "Legacy PC bootmode support" "sys-boot/grub:2[grub_platforms_pc]"
}
