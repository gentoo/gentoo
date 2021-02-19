# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal

DESCRIPTION="Library for playing MOD-like music files"
HOMEPAGE="http://modplug-xmms.sourceforge.net/"
SRC_URI="mirror://sourceforge/modplug-xmms/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x86-solaris"

BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-0.8.4-timidity-patches.patch"
	"${FILESDIR}/${P}-no-fast-math.patch"
)

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE=${S} econf --disable-static
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -type f -name '*.la' -delete || die
}
