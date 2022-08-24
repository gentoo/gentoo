# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_SETUPTOOLS=no
inherit gnome2 distutils-r1 optfeature

DESCRIPTION="A graphical tool for administering virtual machines"
HOMEPAGE="https://virt-manager.org https://github.com/virt-manager/virt-manager"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/virt-manager/virt-manager.git"
	EGIT_BRANCH="main"
	SRC_URI=""
	inherit git-r3
else
	SRC_URI="https://virt-manager.org/download/sources/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="gui policykit sasl"

RDEPEND="
	${PYTHON_DEPS}
	app-cdr/cdrtools
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

DISTUTILS_ARGS=(
	--no-update-icon-cache
	--no-compile-schemas
)

EPYTEST_IGNORE=(
	# Wants to use /tmp osinfo config?
	tests/test_cli.py

	# These seem to be essentially coverage tests
	tests/test_checkprops.py
)

distutils_enable_tests pytest

python_configure() {
	esetup.py configure --default-graphics=spice
}

python_test() {
	export VIRTINST_TEST_SUITE_FORCE_LIBOSINFO=0

	epytest
}

python_install() {
	esetup.py install
}

pkg_preinst() {
	if use gui ; then
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
	use gui && gnome2_pkg_postinst

	optfeature "SSH_ASKPASS program implementation" lxqt-base/lxqt-openssh-askpass net-misc/ssh-askpass-fullscreen net-misc/x11-ssh-askpass
	optfeature "QEMU host support" app-emulation/qemu[usbredir,spice]
	optfeature "virt-install --location ISO support" dev-libs/libisoburn
}
