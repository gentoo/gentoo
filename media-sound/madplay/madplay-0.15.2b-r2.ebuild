# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="The MAD audio player"
HOMEPAGE="http://www.underbit.com/products/mad/"
SRC_URI="https://downloads.sourceforge.net/mad/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~mips ppc ppc64 ~sparc x86"
IUSE="alsa nls"

RDEPEND="
	media-libs/libid3tag:=
	media-libs/libmad
	alsa? ( media-libs/alsa-lib )"
DEPEND="${RDEPEND}"
BDEPEND="nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/${PN}-macos.patch
	"${FILESDIR}"/${P}-fix-autoconf.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_with alsa) \
		--without-esd
}
