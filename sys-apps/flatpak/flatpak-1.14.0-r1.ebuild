# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8,9,10} )

inherit linux-info python-any-r1

SRC_URI="https://github.com/${PN}/${PN}/releases/download/${PV}/${P}.tar.xz"
DESCRIPTION="Linux application sandboxing and distribution framework"
HOMEPAGE="https://flatpak.org/"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="doc introspection policykit seccomp systemd X"
RESTRICT+=" test"

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
	sys-apps/bubblewrap
	sys-apps/dbus
	>=sys-fs/fuse-2.9.9:0=
	sys-apps/xdg-dbus-proxy
	X? (
		x11-apps/xauth
		x11-libs/libXau:=
	)
	x11-libs/gdk-pixbuf:2=
	policykit? ( >=sys-auth/polkit-0.98:= )
	seccomp? ( sys-libs/libseccomp:= )
	systemd? ( sys-apps/systemd:= )
"

DEPEND="${RDEPEND}"
# pyparsing version pinned for https://bugs.gentoo.org/825230
BDEPEND="
	>=sys-devel/automake-1.13.4
	>=sys-devel/gettext-0.18.2
	virtual/pkgconfig
	dev-util/gdbus-codegen
	sys-devel/bison
	introspection? ( >=dev-libs/gobject-introspection-1.40 )
	doc? (
		app-text/xmlto
		dev-libs/libxslt
	)
	$(python_gen_any_dep 'dev-python/pyparsing[${PYTHON_USEDEP}]')
"

PDEPEND="sys-apps/xdg-desktop-portal"

python_check_deps() {
	has_version -b "dev-python/pyparsing[${PYTHON_USEDEP}]"
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
	local myeconfargs=(
		--enable-sandboxed-triggers
		--localstatedir="${EPREFIX}"/var
		--with-system-bubblewrap
		--with-system-dbus-proxy
		$(use_enable X xauth)
		$(use_enable doc documentation)
		$(use_enable doc docbook-docs)
		$(use_enable introspection)
		$(use_enable policykit system-helper)
		$(use_enable seccomp)
		$(use_with systemd)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	# https://projects.gentoo.org/qa/policy-guide/installed-files.html#pg0303
	find "${ED}" -name '*.la' -delete || die
}
