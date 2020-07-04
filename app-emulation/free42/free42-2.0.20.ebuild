# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils toolchain-funcs

MY_PV="${PN}-nologo-${PV}"

DESCRIPTION="An HP-42S Calculator Simulator"
HOMEPAGE="https://thomasokken.com/free42/"
SRC_URI="https://thomasokken.com/free42/upstream/${MY_PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="alsa"

DEPEND="dev-libs/atk
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:2
	x11-libs/pango
	alsa? ( media-libs/alsa-lib )"

RDEPEND="${DEPEND}
	x11-libs/libX11
	x11-libs/libXmu"

S="${WORKDIR}/${MY_PV}"

PATCHES=(
	"${FILESDIR}/${PN}-2.0.10-fix-makefile.patch"
	"${FILESDIR}/${PN}-2.0.10-fix-build-intel-lib.patch"
)

src_prepare() {
	default
}

src_compile() {
	local myconf
	use alsa && myconf="AUDIO_ALSA=yes"
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)" BCD_MATH=1 ${myconf} -C "${S}/gtk"
}

src_install() {
	dodoc CREDITS HISTORY README
	dobin gtk/free42dec
}
