# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vala autotools

DESCRIPTION="LXDE session manager"
HOMEPAGE="https://github.com/lxde/lxsession"
SRC_URI="https://github.com/lxde/lxsession/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~riscv ~x86"
IUSE="nls upower"
# No real tests and as of 0.5.6, fails on an nls linting issue.
RESTRICT="test"

COMMON_DEPEND="
	>=dev-libs/glib-2.32.0:2
	>=lxde-base/lxde-common-0.99.2-r1
	sys-apps/dbus
	sys-auth/polkit
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3[X]
	x11-libs/libX11
"
RDEPEND="
	${COMMON_DEPEND}
	!lxde-base/lxsession-edit
	sys-apps/lsb-release
	upower? ( sys-power/upower )
"
DEPEND="
	${COMMON_DEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	$(vala_depend)
	>=app-text/docbook-xsl-stylesheets-1.70.1
	app-text/docbook-xml-dtd:4.1.2
	dev-libs/libxslt
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=(
	# Fedora patches
	"${FILESDIR}"/${PN}-0.5.2-reload.patch
	"${FILESDIR}"/${PN}-0.5.2-notify-daemon-default.patch
)

src_prepare() {
	# Not needed w/o a release tarball
	#rm *.stamp || die

	vala_setup
	default
	eautoreconf
}

src_configure() {
	# dbus is used for restart/shutdown (logind), and suspend/hibernate (UPower)
	local myeconfargs=(
		--enable-gtk3
		$(use_enable nls)
		# As of 0.5.6, there's no more dist tarballs, but we
		# still want man pages.
		--enable-man
	)

	econf "${myeconfargs[@]}"
}
