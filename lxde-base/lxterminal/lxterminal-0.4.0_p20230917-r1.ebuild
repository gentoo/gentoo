# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools xdg

DESCRIPTION="Lightweight vte-based tabbed terminal emulator for LXDE"
HOMEPAGE="https://wiki.lxde.org/en/LXTerminal"
if [[ ${PV} == *_p* ]] ; then
	TERMINAL_COMMIT="9b4299c292567b371158368686088900a4c0a128"
	SRC_URI="https://github.com/lxde/lxterminal/archive/${TERMINAL_COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/${PN}-${TERMINAL_COMMIT}
else
	SRC_URI="https://downloads.sourceforge.net/lxde/${P}.tar.xz"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~riscv ~x86"

DEPEND="
	dev-libs/glib:2
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/pango
	>=x11-libs/vte-0.28.0:2.91
"
RDEPEND="${DEPEND}"
BDEPEND="
	app-text/docbook-xsl-stylesheets
	>=dev-util/intltool-0.40.0
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.4.0-crash-on-exit.patch
	"${FILESDIR}"/${PN}-0.4.0-c99.patch
)

src_prepare() {
	default

	xdg_environment_reset

	eautoreconf
}

src_configure() {
	econf --enable-man --enable-gtk3
}
