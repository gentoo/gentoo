# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit gnome2 distutils-r1

DESCRIPTION="A graphical tool for administering virtual machines"
HOMEPAGE="http://virt-manager.org"

if [[ ${PV} = *9999* ]]; then
	inherit git-2
	SRC_URI=""
	KEYWORDS=""
	EGIT_REPO_URI="https://github.com/virt-manager/virt-manager.git"
else
	SRC_URI="http://virt-manager.org/download/sources/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

VM_LINGUAS=( as bg bn_IN bs ca cmn cs da de en_GB es fi fr gu hi hr hu is
	it ja kn ko ml mr ms nb nl or pa pl pt pt_BR ro ru sk sr sr@latin sv ta te
	tr uk vi zh_CN zh_TW )

LICENSE="GPL-2"
SLOT="0"
IUSE="gnome-keyring gtk policykit sasl ${VM_LINGUAS[@]/#/linguas_}"

RDEPEND="!app-emulation/virtinst
	dev-python/libvirt-python[${PYTHON_USEDEP}]
	>=app-emulation/libvirt-glib-0.0.9[introspection,python,${PYTHON_USEDEP}]
	${PYTHON_DEPS}
	dev-libs/libxml2[python,${PYTHON_USEDEP}]
	dev-python/ipaddr[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	>=sys-libs/libosinfo-0.2.10[introspection]
	gtk? (
		x11-libs/gtk+:3[introspection]
		gnome-base/dconf
		>=net-libs/gtk-vnc-0.3.8[gtk3,introspection,python,${PYTHON_USEDEP}]
		net-misc/spice-gtk[usbredir,gtk3,introspection,sasl?]
		net-misc/x11-ssh-askpass
		|| ( x11-libs/vte:2.91[introspection] x11-libs/vte:2.90[introspection] )
		gnome-keyring? ( dev-python/gnome-keyring-python )
		policykit? ( sys-auth/polkit[introspection] )
		x11-themes/gnome-icon-theme
	)"
DEPEND="${RDEPEND}
	dev-lang/perl
	dev-util/intltool"

DOCS=( README NEWS )

src_prepare() {
	distutils-r1_src_prepare

	local lang
	for lang in ${VM_LINGUAS[@]}; do
		use linguas_${lang} || rm -v "po/${lang}.po" || die
	done
}

distutils-r1_python_compile() {
	local defgraphics=

	esetup.py configure \
		--qemu-user=qemu \
		--default-graphics=spice
}

src_install() {
	local mydistutilsargs=( --no-update-icon-cache --no-compile-schemas )

	distutils-r1_src_install

	python_fix_shebang \
		"${ED}"/usr/share/virt-manager/virt-{clone,convert,install,manager}
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
