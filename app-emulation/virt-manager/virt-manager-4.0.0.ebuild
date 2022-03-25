# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8,9,10} )
DISTUTILS_SINGLE_IMPL=1

DISTUTILS_USE_SETUPTOOLS=no
inherit gnome2 distutils-r1 optfeature

DESCRIPTION="A graphical tool for administering virtual machines"
HOMEPAGE="https://virt-manager.org https://github.com/virt-manager/virt-manager"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/virt-manager/virt-manager.git"
	EGIT_BRANCH="master"
else
	SRC_URI="http://virt-manager.org/download/sources/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="gtk policykit sasl"

RDEPEND="${PYTHON_DEPS}
	app-cdr/cdrtools
	>=app-emulation/libvirt-glib-1.0.0[introspection]
	$(python_gen_cond_dep '
		dev-libs/libxml2[python,${PYTHON_USEDEP}]
		dev-python/argcomplete[${PYTHON_USEDEP}]
		>=dev-python/libvirt-python-6.10.0[${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
	')
	>=sys-libs/libosinfo-0.2.10[introspection]
	gtk? (
		gnome-base/dconf
		>=net-libs/gtk-vnc-0.3.8[gtk3(+),introspection]
		net-misc/spice-gtk[usbredir,gtk3,introspection,sasl?]
		policykit? ( sys-auth/polkit[introspection] )
		sys-apps/dbus[X]
		x11-libs/gtk+:3[introspection]
		x11-libs/gtksourceview:4[introspection]
		x11-libs/vte:2.91[introspection]
	)"
DEPEND="${RDEPEND}"
BDEPEND="dev-python/docutils"

DOCS=( README.md NEWS.md )

# Doesn't seem to play nicely in a sandboxed environment.
RESTRICT="test"
distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare
}

python_configure() {
	esetup.py configure --default-graphics=spice
}

python_install() {
	esetup.py install
}

src_install() {
	local DISTUTILS_ARGS=( --no-update-icon-cache --no-compile-schemas )
	distutils-r1_src_install
}

pkg_preinst() {
	if use gtk; then
		gnome2_pkg_preinst

		cd "${ED}" || die
		export GNOME2_ECLASS_ICONS=$(find 'usr/share/virt-manager/icons' -maxdepth 1 -mindepth 1 -type d 2> /dev/null || die)
	else
		rm -r "${ED}/usr/share/virt-manager/ui/" || die
		rm -r "${ED}/usr/share/virt-manager/icons/" || die
		rm -r "${ED}/usr/share/icons/" || die
		rm -r "${ED}/usr/share/applications/virt-manager.desktop" || die
		rm -r "${ED}/usr/bin/virt-manager" || die
	fi
}

pkg_postinst() {
	use gtk && gnome2_pkg_postinst
	optfeature "SSH_ASKPASS program implementation" lxqt-base/lxqt-openssh-askpass net-misc/ssh-askpass-fullscreen net-misc/x11-ssh-askpass
	optfeature "QEMU host support" app-emulation/qemu[usbredir,spice]
}
