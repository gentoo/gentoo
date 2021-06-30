# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{7,8,9} )
DISTUTILS_SINGLE_IMPL=1

DISTUTILS_USE_SETUPTOOLS=no
inherit gnome2 distutils-r1

DESCRIPTION="A graphical tool for administering virtual machines"
HOMEPAGE="http://virt-manager.org"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/virt-manager/virt-manager.git"
	EGIT_BRANCH="master"
else
	SRC_URI="http://virt-manager.org/download/sources/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~ppc64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="gtk policykit sasl"

RDEPEND="${PYTHON_DEPS}
	app-cdr/cdrtools
	>=app-emulation/libvirt-glib-1.0.0[introspection]
	$(python_gen_cond_dep '
		dev-libs/libxml2[python,${PYTHON_MULTI_USEDEP}]
		dev-python/argcomplete[${PYTHON_MULTI_USEDEP}]
		>=dev-python/libvirt-python-6.10.0[${PYTHON_MULTI_USEDEP}]
		dev-python/pygobject:3[${PYTHON_MULTI_USEDEP}]
		dev-python/requests[${PYTHON_MULTI_USEDEP}]
		dev-python/tqdm[${PYTHON_MULTI_USEDEP}]
	')
	>=sys-libs/libosinfo-0.2.10[introspection]
	gtk? (
		gnome-base/dconf
		>=net-libs/gtk-vnc-0.3.8[gtk3(+),introspection]
		net-misc/spice-gtk[usbredir,gtk3,introspection,sasl?]
		net-misc/x11-ssh-askpass
		x11-libs/gtk+:3[introspection]
		x11-libs/gtksourceview:4[introspection]
		x11-libs/vte:2.91[introspection]
		policykit? ( sys-auth/polkit[introspection] )
	)
"
DEPEND="${RDEPEND}
	dev-python/docutils
	dev-util/intltool
"

distutils_enable_tests pytest

DOCS=( README.md NEWS.md )

src_prepare() {
	distutils-r1_src_prepare
}

python_configure() {
	esetup.py configure \
		--default-graphics=spice
}

python_install() {
	esetup.py install
}

src_install() {
	local mydistutilsargs=( --no-update-icon-cache --no-compile-schemas )
	distutils-r1_src_install
}

pkg_preinst() {
	if use gtk; then
		gnome2_pkg_preinst

		cd "${ED}"
		export GNOME2_ECLASS_ICONS=$(find 'usr/share/virt-manager/icons' -maxdepth 1 -mindepth 1 -type d 2> /dev/null)
	else
		rm -rf "${ED}/usr/share/virt-manager/virtManager"
		rm -f "${ED}/usr/share/virt-manager/virt-manager"
		rm -rf "${ED}/usr/share/virt-manager/ui/"
		rm -rf "${ED}/usr/share/virt-manager/icons/"
		rm -rf "${ED}/usr/share/man/man1/virt-manager.1*"
		rm -rf "${ED}/usr/share/icons/"
		rm -rf "${ED}/usr/share/applications/virt-manager.desktop"
		rm -rf "${ED}/usr/bin/virt-manager"
	fi
}

pkg_postinst() {
	use gtk && gnome2_pkg_postinst
}
