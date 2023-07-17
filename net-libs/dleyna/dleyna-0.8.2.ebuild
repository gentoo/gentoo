# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9..11} )

inherit meson python-single-r1

DESCRIPTION="A set of services and D-Bus APIs to simplify access to UPnP/DLNA media devices"
HOMEPAGE="https://gitlab.gnome.org/World/dLeyna"
SRC_URI="https://gitlab.gnome.org/World/dLeyna/-/archive/v${PV}/dLeyna-v${PV}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="1.0/6" # soname of libdleyna-core-1.0.so
KEYWORDS="amd64 ~riscv x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	>=dev-libs/glib-2.28:2
	>=net-libs/gssdp-1.6.0:1.6=
	>=net-libs/gupnp-1.6.0:1.6=
	>=net-libs/gupnp-av-0.12.9:0=
	>=media-libs/gupnp-dlna-0.9.4:2.0=
	>=net-libs/libsoup-3.0:3.0
	dev-libs/libxml2

	${PYTHON_DEPS}

	!net-libs/dleyna-connector-dbus
	!net-libs/dleyna-core
	!net-libs/dleyna-renderer
	!net-misc/dleyna-server
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-python/docutils
	virtual/pkgconfig
"

S="${WORKDIR}"/dLeyna-v${PV}

PATCHES=(
	"${FILESDIR}"/meson-1.2.0.patch
)

src_configure() {
	local emesonargs=(
		-Ddbus_service_dir="${EPREFIX}/usr/share/dbus-1/services"
		-Dman_pages=true
		-Ddocs=false
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	python_optimize
}
