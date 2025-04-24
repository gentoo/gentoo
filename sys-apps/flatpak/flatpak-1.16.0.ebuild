# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..13} )

inherit linux-info meson python-any-r1 systemd tmpfiles

DESCRIPTION="Linux application sandboxing and distribution framework"
HOMEPAGE="https://flatpak.org/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${PV}/${P}.tar.xz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ~ppc64 ~riscv x86"
IUSE="doc introspection seccomp systemd X"
RESTRICT="test"

RDEPEND="
	acct-group/flatpak
	acct-user/flatpak
	>=app-arch/libarchive-2.8:=
	app-arch/zstd:=
	>=app-crypt/gpgme-1.1.8:=
	>=dev-libs/appstream-0.12:=
	>=dev-libs/appstream-glib-0.5.10:=
	>=dev-libs/glib-2.56:2=
	>=dev-libs/libxml2-2.4:=
	dev-libs/json-glib:=
	dev-libs/libassuan:=
	>=dev-util/ostree-2020.8:=[gpg(+)]
	dev-util/ostree[curl]
	>=gnome-base/dconf-0.26:=
	gnome-base/gsettings-desktop-schemas
	net-misc/curl:=
	net-misc/socat
	>=sys-apps/bubblewrap-0.10.0
	sys-apps/dbus
	>=sys-fs/fuse-3.1.1:3=
	sys-apps/xdg-dbus-proxy
	sys-auth/polkit
	X? (
		x11-apps/xauth
		x11-libs/libXau:=
	)
	x11-libs/gdk-pixbuf:2=
	seccomp? ( sys-libs/libseccomp:= )
	systemd? ( sys-apps/systemd:= )
"

DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-build/automake-1.13.4
	>=sys-devel/gettext-0.18.2
	virtual/pkgconfig
	dev-util/gdbus-codegen
	dev-util/glib-utils
	app-alternatives/yacc
	$(python_gen_any_dep 'dev-python/pyparsing[${PYTHON_USEDEP}]')
	introspection? ( >=dev-libs/gobject-introspection-1.40 )
	doc? (
		app-text/xmlto
		dev-libs/libxslt
	)
"

PDEPEND="sys-apps/xdg-desktop-portal"

python_check_deps() {
	python_has_version "dev-python/pyparsing[${PYTHON_USEDEP}]"
}

pkg_setup() {
	local CONFIG_CHECK="~USER_NS"
	linux-info_pkg_setup
	python-any-r1_pkg_setup
}

src_prepare() {
	default
	# This line fails because locales are in /usr/lib/locale/locale-archive.
	sed -i 's:^cp -r /usr/lib/locale/C.*:#\0:' tests/make-test-runtime.sh || die
}

src_configure() {
	local emesonargs=(
		--localstatedir="${EPREFIX}"/var
		-Ddbus_config_dir=/usr/share/dbus-1/system.d
		-Dsystem_bubblewrap=bwrap
		-Dsystem_dbus_proxy=xdg-dbus-proxy
		-Dtmpfilesdir=/usr/lib/tmpfiles.d
		$(meson_feature introspection gir)
		$(meson_feature X xauth)
		$(meson_feature doc docbook_docs)
		$(meson_feature seccomp seccomp)
		$(meson_feature systemd systemd)
	)

	meson_src_configure
}

src_install() {
	meson_src_install
	# https://projects.gentoo.org/qa/policy-guide/installed-files.html#pg0303
	find "${ED}" -name '*.la' -delete || die
	# resolve conflict with acct-user/flatpak for #856706
	rm -rf "${ED}/usr/lib/sysusers.d"

	if use systemd; then
	   systemd_dounit "${FILESDIR}"/flatpak-update.{service,timer}
	fi
}

pkg_postinst() {
	tmpfiles_process flatpak.conf
}
