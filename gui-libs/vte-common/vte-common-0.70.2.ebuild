# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9..11} )

inherit gnome.org meson python-any-r1

DESCRIPTION="Library providing a virtual terminal emulator widget"
HOMEPAGE="https://wiki.gnome.org/Apps/Terminal/VTE"

# Once SIXEL support ships (0.66 or later), might need xterm license (but code might be considered upgraded to LGPL-3+)
LICENSE="LGPL-3+ GPL-3+"
SLOT="2.91" # vte_api_version in meson.build
IUSE="systemd"
KEYWORDS="amd64 arm arm64 ~ia64 ~loong ppc ppc64 ~riscv sparc x86"

# Upstream is hostile and refuses to upload tarballs.
SRC_URI="https://gitlab.gnome.org/GNOME/vte/-/archive/${PV}/vte-${PV}.tar.bz2"

DEPEND="
	|| ( >=gui-libs/gtk-4.0.1:4 >=x11-libs/gtk+-3.24.22:3 )
	>=dev-libs/fribidi-1.0.0
	>=dev-libs/glib-2.52:2
	>=x11-libs/pango-1.22.0
	>=dev-libs/libpcre2-10.21
	systemd? ( >=sys-apps/systemd-220:= )
	sys-libs/zlib
	x11-libs/pango
"
RDEPEND="
	!<x11-libs/vte-0.70.0:2.91
"
BDEPEND="
	${PYTHON_DEPS}
	dev-libs/libxml2:2
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

S="${WORKDIR}/vte-${PV}"

src_prepare() {
	default
	use elibc_musl && eapply "${FILESDIR}"/${PN}-0.70.0-musl-W_EXITCODE.patch
}

src_configure() {
	local emesonargs=(
		-Da11y=false
		-Ddebugg=false
		-Ddocs=false
		-Dgir=false
		-Dfribidi=true # pulled in by pango anyhow
		-Dglade=false
		-Dgnutls=false
		-Dgtk3=false
		-Dgtk4=false
		-Dicu=false
		$(meson_use systemd _systemd)
		-Dvapi=false
	)
	meson_src_configure
}

src_install() {
	exeinto /usr/libexec/
	doexe "${BUILD_DIR}"/src/vte-urlencode-cwd
	insinto /etc/profile.d/
	newins "${BUILD_DIR}"/src/vte.sh vte-${SLOT}.sh
	newins "${BUILD_DIR}"/src/vte.csh vte-${SLOT}.csh
	if  use systemd; then
		insinto /usr/lib/systemd/user/vte-spawn-.scode.d/
		newins "${S}"/src/vte-spawn-.scope.conf defaults.conf
	fi
	einstalldocs
}
