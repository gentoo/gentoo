# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit meson pam python-any-r1 systemd

MY_P="${PN}-v${PV}"

DESCRIPTION="D-Bus service to access fingerprint readers"
HOMEPAGE="https://gitlab.freedesktop.org/libfprint/fprintd"
SRC_URI="https://gitlab.freedesktop.org/libfprint/${PN}/-/archive/v${PV}/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc x86"
IUSE="doc pam selinux systemd test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/dbus-glib
	dev-libs/glib:2
	>=sys-auth/libfprint-1.94.0:2
	sys-auth/polkit
	pam? (
		sys-libs/pam
		systemd? ( sys-apps/systemd:= )
		!systemd? ( sys-auth/elogind:= )
	)
"

DEPEND="
	${RDEPEND}
	test? (
		$(python_gen_any_dep '
			dev-python/python-dbusmock[${PYTHON_USEDEP}]
			dev-python/dbus-python[${PYTHON_USEDEP}]
			dev-python/pycairo[${PYTHON_USEDEP}]
			pam? ( sys-libs/pam_wrapper[${PYTHON_USEDEP}] )
		')
	)
"

BDEPEND="
	dev-lang/perl
	dev-util/gdbus-codegen
	virtual/pkgconfig
	doc? (
		dev-libs/libxml2
		dev-libs/libxslt
		dev-util/gtk-doc
	)
"

RDEPEND+=" selinux? ( sec-policy/selinux-fprintd )"

PATCHES=(
	"${FILESDIR}/fprintd-1.94.3-test-optional.patch"
)

python_check_deps() {
	if use test; then
		python_has_version -d "sys-libs/pam_wrapper[${PYTHON_USEDEP}]"
	fi

	python_has_version -d "dev-python/python-dbusmock[${PYTHON_USEDEP}]" &&
	python_has_version -d "dev-python/dbus-python[${PYTHON_USEDEP}]" &&
	python_has_version -d "dev-python/pycairo[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_configure() {
	local emesonargs=(
		$(meson_use test tests)
		$(meson_use pam)
		-Dgtk_doc=$(usex doc true false)
		-Dman=true
		-Dsystemd_system_unit_dir=$(systemd_get_systemunitdir)
		-Dpam_modules_dir=$(getpam_mod_dir)
		-Dlibsystemd=$(usex systemd libsystemd libelogind)
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	dodoc AUTHORS NEWS README TODO
	newdoc pam/README README.pam_fprintd
}

pkg_postinst() {
	elog "Please take a look at README.pam_fprintd for integration docs."
}
