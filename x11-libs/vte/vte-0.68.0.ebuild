# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..10} )
VALA_MIN_API_VERSION="0.48"

inherit gnome.org meson python-any-r1 vala xdg

DESCRIPTION="Library providing a virtual terminal emulator widget"
HOMEPAGE="https://wiki.gnome.org/Apps/Terminal/VTE https://gitlab.gnome.org/GNOME/vte"

# Once SIXEL support ships (0.66 or later), might need xterm license (but code might be considered upgraded to LGPL-3+)
LICENSE="LGPL-3+ GPL-3+"
SLOT="2.91"
IUSE="+crypt debug gtk-doc +icu +introspection systemd +vala vanilla"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-solaris ~x86-solaris"
REQUIRED_USE="vala? ( introspection )"

# Upstream is hostile and refuses to upload tarballs.
SRC_URI="https://gitlab.gnome.org/GNOME/${PN}/-/archive/${PV}/${P}.tar.bz2"
SRC_URI="${SRC_URI} !vanilla? ( https://dev.gentoo.org/~mattst88/distfiles/${PN}-0.68.0-command-notify.patch.xz )"

RDEPEND="
	>=x11-libs/gtk+-3.24.22:3[introspection?]
	>=dev-libs/fribidi-1.0.0
	>=dev-libs/glib-2.52:2
	crypt?  ( >=net-libs/gnutls-3.2.7:0= )
	icu? ( dev-libs/icu:= )
	>=x11-libs/pango-1.22.0
	>=dev-libs/libpcre2-10.21
	systemd? ( >=sys-apps/systemd-220:= )
	sys-libs/zlib
	introspection? ( >=dev-libs/gobject-introspection-1.56:= )
	x11-libs/pango[introspection?]
"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	dev-libs/libxml2:2
	dev-util/glib-utils
	gtk-doc? ( >=dev-util/gtk-doc-1.13
		app-text/docbook-xml-dtd:4.1.2 )
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig

	vala? ( $(vala_depend) )
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.64.1-meson-Find-python-explicitly-to-honor-downstream-pyt.patch
)

src_prepare() {
	default
	use vala && vala_setup
	xdg_environment_reset

	use elibc_musl && eapply "${FILESDIR}"/${PN}-0.66.2-musl-W_EXITCODE.patch

	if ! use vanilla; then
		# Part of https://src.fedoraproject.org/rpms/vte291/raw/f31/f/vte291-cntnr-precmd-preexec-scroll.patch
		# Adds OSC 777 support for desktop notifications in gnome-terminal or elsewhere
		eapply "${WORKDIR}"/${PN}-0.68.0-command-notify.patch
	fi

	# -Ddebugg option enables various debug support via VTE_DEBUG, but also ggdb3; strip the latter
	sed -e '/ggdb3/d' -i meson.build || die
}

src_configure() {
	local emesonargs=(
		-Da11y=true
		$(meson_use debug debugg)
		$(meson_use gtk-doc docs)
		$(meson_use introspection gir)
		-Dfribidi=true # pulled in by pango anyhow
		-Dglade=true
		$(meson_use crypt gnutls)
		-Dgtk3=true
		-Dgtk4=false
		$(meson_use icu)
		$(meson_use systemd _systemd)
		$(meson_use vala vapi)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	mv "${ED}"/etc/profile.d/vte{,-${SLOT}}.sh || die
}
