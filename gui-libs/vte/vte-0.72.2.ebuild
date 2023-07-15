# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..12} )

inherit gnome.org meson python-any-r1 vala xdg

DESCRIPTION="Library providing a virtual terminal emulator widget"
HOMEPAGE="https://wiki.gnome.org/Apps/Terminal/VTE"

# Once SIXEL support ships (0.66 or later), might need xterm license (but code might be considered upgraded to LGPL-3+)
LICENSE="LGPL-3+ GPL-3+"
SLOT="2.91-gtk4" # vte_api_version + "-gtk4" in meson.build
IUSE="+crypt debug gtk-doc +icu +introspection systemd +vala vanilla"
KEYWORDS="amd64 ~arm ~arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
REQUIRED_USE="
	gtk-doc? ( introspection )
	vala? ( introspection )
"

# Upstream is hostile and refuses to upload tarballs.
SRC_URI="https://gitlab.gnome.org/GNOME/${PN}/-/archive/${PV}/${P}.tar.bz2"
SRC_URI="${SRC_URI} !vanilla? ( https://dev.gentoo.org/~mattst88/distfiles/${PN}-0.70.0-command-notify.patch.xz )"

DEPEND="
	>=gui-libs/gtk-4.0.1:4[introspection?]
	>=dev-libs/fribidi-1.0.0
	>=dev-libs/glib-2.60:2
	crypt?  ( >=net-libs/gnutls-3.2.7:0= )
	icu? ( dev-libs/icu:= )
	>=x11-libs/pango-1.22.0
	>=dev-libs/libpcre2-10.21:=
	systemd? ( >=sys-apps/systemd-220:= )
	sys-libs/zlib
	introspection? ( >=dev-libs/gobject-introspection-1.56:= )
	x11-libs/pango[introspection?]
"
RDEPEND="${DEPEND}
	~gui-libs/vte-common-${PV}[systemd?]
"
BDEPEND="
	${PYTHON_DEPS}
	dev-libs/libxml2:2
	dev-util/glib-utils
	gtk-doc? ( dev-util/gi-docgen )
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"

src_prepare() {
	default
	use vala && vala_setup
	xdg_environment_reset

	use elibc_musl && eapply "${FILESDIR}"/${PN}-0.66.2-musl-W_EXITCODE.patch

	if ! use vanilla; then
		# Part of https://src.fedoraproject.org/rpms/vte291/raw/f37/f/vte291-cntnr-precmd-preexec-scroll.patch
		# Adds OSC 777 support for desktop notifications in gnome-terminal or elsewhere
		eapply "${WORKDIR}"/${PN}-0.70.0-command-notify.patch
	fi

	# -Ddebugg option enables various debug support via VTE_DEBUG, but also ggdb3; strip the latter
	sed -e '/ggdb3/d' -i meson.build || die
	sed -i 's/vte_gettext_domain = vte_api_name/vte_gettext_domain = vte_gtk4_api_name/' meson.build || die
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
		-Dgtk3=false
		-Dgtk4=true
		$(meson_use icu)
		$(meson_use systemd _systemd)
		$(meson_use vala vapi)
	)
	meson_src_configure
}

src_install() {
	# not meson_src_install because this would include einstalldocs, which
	# would result in file collisions with x11-libs/vte
	meson_install

	# Remove files that are provided by gui-libs/vte-common
	rm "${ED}"/usr/libexec/vte-urlencode-cwd || die
	rm "${ED}"/etc/profile.d/vte.sh || die
	rm "${ED}"/etc/profile.d/vte.csh || die
	if use systemd; then
		rm "${ED}"/usr/lib/systemd/user/vte-spawn-.scope.d/defaults.conf || die
	fi
	if use gtk-doc; then
		mkdir -p "${ED}"/usr/share/gtk-doc/ || die
		mv "${ED}"/usr/share/doc/vte-${SLOT} "${ED}"/usr/share/gtk-doc/ || die
	fi
}
