# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
inherit gnome2 python-single-r1 optfeature meson

DESCRIPTION="A graphical tool for administering virtual machines"
HOMEPAGE="https://virt-manager.org https://github.com/virt-manager/virt-manager"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/virt-manager/virt-manager.git"
	EGIT_BRANCH="main"
	SRC_URI=""
	inherit git-r3
else
	SRC_URI="https://releases.pagure.org/${PN}/${P}.tar.xz"
	KEYWORDS="amd64 arm64 ppc64 x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="gui policykit sasl"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	|| ( dev-libs/libisoburn app-cdr/cdrtools )
	>=app-emulation/libvirt-glib-1.0.0[introspection]
	>=sys-libs/libosinfo-0.2.10[introspection]
	$(python_gen_cond_dep '
		dev-libs/libxml2[python,${PYTHON_USEDEP}]
		dev-python/argcomplete[${PYTHON_USEDEP}]
		>=dev-python/libvirt-python-6.10.0[${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
	')
	gui? (
		gnome-base/dconf
		>=net-libs/gtk-vnc-0.3.8[gtk3(+),introspection]
		net-misc/spice-gtk[usbredir,gtk3,introspection,sasl?]
		sys-apps/dbus[X]
		x11-libs/gtk+:3[introspection]
		x11-libs/gtksourceview:4[introspection]
		x11-libs/vte:2.91[introspection]
		policykit? ( sys-auth/polkit[introspection] )
	)
"
DEPEND="${RDEPEND}"
BDEPEND="dev-python/docutils"

DOCS=( README.md NEWS.md )

src_configure() {
	# While in the past we did allow test suite to run, any errors from
	# test_cli.py were ignored. Since that's where like 90% of tests actually
	# lives, just disable tests (and do not drag additional dependencies).
	local emesonargs=(
		-Dcompile-schemas=false
		-Ddefault-graphics=spice
		-Dtests=disabled
		-Dupdate-icon-cache=false
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	if ! use gui ; then
		rm -r "${ED}/usr/share/virt-manager/ui/" || die
		rm -r "${ED}/usr/share/virt-manager/icons/" || die
		rm -r "${ED}/usr/share/icons/" || die
		rm -r "${ED}/usr/share/applications/virt-manager.desktop" || die
		rm -r "${ED}/usr/bin/virt-manager" || die
	fi

	python_fix_shebang "${ED}"
}

pkg_postinst() {
	use gui && gnome2_pkg_postinst

	optfeature "SSH_ASKPASS program implementation" lxqt-base/lxqt-openssh-askpass net-misc/ssh-askpass-fullscreen net-misc/x11-ssh-askpass
	optfeature "QEMU host support" app-emulation/qemu[usbredir,spice]
}
