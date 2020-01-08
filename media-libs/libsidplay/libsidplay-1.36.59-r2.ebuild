# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit libtool multilib-minimal

DESCRIPTION="C64 SID player library"
HOMEPAGE="http://critical.ch/distfiles/"
SRC_URI="http://critical.ch/distfiles/${P}.tgz"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE="static-libs"
DEPEND=""
RDEPEND=""

DOCS=( AUTHORS DEVELOPER )
PATCHES=(
	"${FILESDIR}"/${P}-gcc43.patch
	"${FILESDIR}"/${P}-fix-c++14.patch
)

src_prepare() {
	default
	elibtoolize # required for fbsd .so versioning
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" \
	econf $(use_enable static-libs static)
}

multilib_src_install_all() {
	einstalldocs
	find "${D}" -name '*.la' -delete || die
}
