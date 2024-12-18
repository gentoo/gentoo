# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )
inherit distutils-r1

DESCRIPTION="Tweak tool for the MATE Desktop"
HOMEPAGE="https://github.com/ubuntu-mate/mate-tweak"
SRC_URI="https://github.com/ubuntu-mate/mate-tweak/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dropdown"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/distro[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/setproctitle[${PYTHON_USEDEP}]
	')
	gnome-base/dconf
	x11-libs/libnotify
	mate-base/libmatekbd
	mate-base/mate-panel
	dropdown? ( x11-terms/tilda )
"

BDEPEND="
	dev-util/intltool
	net-misc/rsync
	sys-devel/gettext
"

PATCHES=(
	"${FILESDIR}/mate-tweak-22.10.0-avoid-distutilsextra.patch"
)

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	# Correct paths in mate-tweak script - makes "Window Behavior" options work
	# from https://github.com/shiznix/unity-gentoo/blob/master/mate-extra/mate-tweak/mate-tweak-22.10.0_p_p0_p01.ebuild
	sed -e "s:brisk-menu/brisk-menu:brisk-menu:g" \
		-e "s:/usr/lib/mate-netbook/mate-window-picker-applet:/usr/libexec/mate-window-picker-applet:g" \
		-e "s:/usr/lib/MULTIARCH:MULTIARCH:g" \
		-e "s:'/usr/lib/' + self.multiarch + :self.multiarch + :g" \
		-e "/self.multiarch = sysconfig.get_config_var/c\        self.multiarch = os.path.join('/','usr','libexec')" \
		-e "s:self.multiarch + '/mate-panel/libappmenu-mate.so':'/usr/$(get_libdir)/mate-panel/libappmenu-mate.so':g" \
			-i mate-tweak || die

	distutils-r1_src_prepare
}

src_install() {
	distutils-r1_src_install
	rsync -av "${ED}"/usr/lib/python*/site-packages/usr/ "${ED}"/usr || die
	rm -r "${ED}"/usr/lib/python*/site-packages/{usr,__pycache__,setup.py} || die
	python_fix_shebang "${ED}"
}
