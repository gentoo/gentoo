# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit autotools

DESCRIPTION="Macro recording plugin to G15daemon"
HOMEPAGE="https://gitlab.com/menelkir/g15macro"
if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/menelkir/g15macro.git"
else
	SRC_URI="https://gitlab.com/menelkir/${PN}/-/archive/${PV}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND=">=app-misc/g15daemon-3.0
	>=dev-libs/libg15-3.0
	>=dev-libs/libg15render-3.0
	x11-libs/libX11
	x11-libs/libXtst
"
RDEPEND="${DEPEND}
	sys-libs/zlib
"

PATCHES=(
	"${FILESDIR}/${PN}-1.0.5-autoconf_fixes.patch"
)

src_prepare() {
	mv configure.{in,ac} || die
	default
	eautoreconf
}

src_configure() {
	econf --enable-xtest
}
