# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
PYTHON_REQ_USE="xml(+)"
GNOME2_EAUTORECONF="yes"

inherit gnome2 python-any-r1 virtualx

DESCRIPTION="Daemon that centralizes the communication logging within the Telepathy framework"
HOMEPAGE="https://telepathy.freedesktop.org/components/telepathy-logger/"
# FIXME: Debian upstream uses 4.x for the latest patches, hopefully they
# will release _p5 to fix this in the near future
SRC_URI="https://telepathy.freedesktop.org/releases/${PN}/${P/_p*}.tar.bz2
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV/_p*}-${PV/*_p}.2.debian.tar.xz"
S="${WORKDIR}/${P/_p*}"

LICENSE="LGPL-2.1+"
SLOT="0/3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86 ~x86-linux"
IUSE="+introspection"

RDEPEND="
	>=dev-libs/glib-2.28:2
	>=sys-apps/dbus-1.1
	>=dev-libs/dbus-glib-0.82
	>=net-libs/telepathy-glib-0.19.2[introspection?]
	dev-libs/libxml2:=
	dev-libs/libxslt
	dev-db/sqlite:3
	introspection? ( >=dev-libs/gobject-introspection-0.9.6 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	dev-util/glib-utils
	>=dev-build/gtk-doc-am-1.10
	>=dev-util/intltool-0.35
	virtual/pkgconfig
"

src_prepare() {
	# Debian patches
	for p in $(<"${WORKDIR}"/debian/patches/series) ; do
		eapply -p1 "${WORKDIR}/debian/patches/${p}"
	done
	gnome2_src_prepare
}

src_configure() {
	# --enable-debug needed due to https://bugs.freedesktop.org/show_bug.cgi?id=83390
	gnome2_src_configure \
		$(use_enable introspection) \
		--enable-debug \
		--enable-public-extensions \
		--disable-coding-style-checks \
		--disable-Werror \
		--disable-static
}

src_test() {
	virtx emake -j1 check
}
