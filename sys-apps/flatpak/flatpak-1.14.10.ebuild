# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..12} )

inherit linux-info python-any-r1 systemd tmpfiles

DESCRIPTION="Linux application sandboxing and distribution framework"
HOMEPAGE="https://flatpak.org/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${PV}/${P}.tar.xz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="doc introspection policykit seccomp systemd X"
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
	>=sys-apps/bubblewrap-0.10.0
	sys-apps/dbus
	>=sys-fs/fuse-3.1.1:3=
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

PATCHES=(
	"${FILESDIR}"/${PN}-1.14.4-fuse-3-slotted.patch
)

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
	local myeconfargs=(
		--enable-sandboxed-triggers
		--localstatedir="${EPREFIX}"/var
		--with-system-bubblewrap
		--with-system-dbus-proxy
		--with-tmpfilesdir="/usr/lib/tmpfiles.d"
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
	# resolve conflict with acct-user/flatpak for #856706
	rm -rf "${ED}/usr/lib/sysusers.d"

	if use systemd; then
	   systemd_dounit "${FILESDIR}"/flatpak-update.{service,timer}
	fi
}

pkg_postinst() {
	tmpfiles_process flatpak.conf
}
