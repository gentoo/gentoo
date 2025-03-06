# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
inherit gnome2 python-single-r1 optfeature meson verify-sig

DESCRIPTION="A graphical tool for administering virtual machines"
HOMEPAGE="https://virt-manager.org https://github.com/virt-manager/virt-manager"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/virt-manager/virt-manager.git"
	EGIT_BRANCH="main"
	SRC_URI=""
	inherit git-r3
else
	SRC_URI="
		https://releases.pagure.org/${PN}/${P}.tar.xz
		verify-sig? ( https://releases.pagure.org/${PN}/${P}.tar.xz.asc	)
	"
	KEYWORDS="~amd64 arm64 ppc64 x86"
fi

LICENSE="GPL-2+"
SLOT="0"
IUSE="gui policykit sasl verify-sig"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# https://github.com/virt-manager/virt-manager/blob/main/virt-manager.spec.in
RDEPEND="
	${PYTHON_DEPS}
	|| ( dev-libs/libisoburn app-cdr/cdrtools )
	>=app-emulation/libvirt-glib-0.0.9[introspection]
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
		sys-apps/dbus
		x11-libs/gtk+:3[introspection]
		|| (
			x11-libs/gtksourceview:4[introspection]
			x11-libs/gtksourceview:3.0[introspection]
		)
		x11-libs/vte:2.91[introspection]
		policykit? ( sys-auth/polkit[introspection] )
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-python/docutils
	sys-devel/gettext
	verify-sig? ( >=sec-keys/openpgp-keys-virt-manager-20250106 )
"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/virt-manager.asc

DOCS=( {DESIGN,NEWS,README}.md )

src_configure() {
	local emesonargs=( # in upstream's order
		-Dupdate-icon-cache=false
		-Dcompile-schemas=false

		# -Ddefault-graphics=spice # default
		# we do not ship OpenVZ and bhyve does not work on linux
		-Ddefault-hvs="['qemu','xen','lxc']"

		# While in the past we did allow test suite to run, any errors from
		# test_cli.py were ignored. Since that's where like 90% of tests actually
		# lives, just disable tests (and do not drag additional dependencies).
		-Dtests=disabled
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	if ! use gui; then
		rm -r "${ED}/usr/share/applications/${PN}.desktop" || die
		rm -r "${ED}/usr/share/${PN}/icons/" || die
		rm -r "${ED}/usr/share/${PN}/ui/" || die
		rm -r "${ED}/usr/share/icons/" || die
		rm -r "${ED}/usr/bin/${PN}" || die
	fi

	python_fix_shebang "${ED}"
}

pkg_postinst() {
	use gui && gnome2_pkg_postinst

	optfeature "Full QEMU host support" app-emulation/qemu[usbredir,spice]
	optfeature "SSH_ASKPASS program implementation" lxqt-base/lxqt-openssh-askpass \
		net-misc/ssh-askpass-fullscreen net-misc/x11-ssh-askpass
	# it's possible this also requires libguestfs-appliance but it's a RDEPEND of libguestfs
	optfeature "Inspection of guest filesystems" app-emulation/libguestfs[libvirt,python]
}
