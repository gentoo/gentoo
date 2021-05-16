# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson pam systemd

DESCRIPTION="D-Bus service to access fingerprint readers"
HOMEPAGE="https://gitlab.freedesktop.org/libfprint/fprintd"
SRC_URI="https://gitlab.freedesktop.org/libfprint/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ia64 x86"
IUSE="doc pam systemd test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/dbus-glib
	dev-libs/glib:2
	sys-auth/libfprint:2
	sys-auth/polkit
	pam? (
		systemd? ( sys-apps/systemd )
		!systemd? ( sys-auth/elogind )
		sys-libs/pam
	)
"
DEPEND="${RDEPEND}"

BDEPEND="
	dev-lang/perl
	doc? (
		dev-libs/libxml2
		dev-libs/libxslt
		dev-util/gtk-doc
	)
	test? (
		dev-python/dbusmock
		dev-python/dbus-python
		dev-python/pycairo
		pam? ( sys-libs/pam_wrapper )
	)
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${PN}-1.90.7_0001-add-test-feature-and-make-tests-optional.patch"
	"${FILESDIR}/${PN}-1.90.8_0002-add-configure-option-for-libsystemd-provider.patch"
)

S="${WORKDIR}/${PN}-v${PV}"

src_configure() {
		local emesonargs=(
			$(meson_feature test)
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
