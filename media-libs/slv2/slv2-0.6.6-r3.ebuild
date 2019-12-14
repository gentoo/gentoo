# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='threads(+)'
inherit eutils multilib python-any-r1 toolchain-funcs waf-utils

DESCRIPTION="A library to make the use of LV2 plugins as simple as possible for applications"
HOMEPAGE="http://wiki.drobilla.net/SLV2"
SRC_URI="http://download.drobilla.net/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc jack"

BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"
CDEPEND="
	>=dev-libs/redland-1.0.6
	jack? ( virtual/jack )
	media-libs/lv2
"
RDEPEND="${CDEPEND}"
DEPEND="
	${CDEPEND}
	${PYTHON_DEPS}
"

PATCHES=(
	"${FILESDIR}"/ldconfig.patch
	"${FILESDIR}"/${P}-raptor2-link.patch
	"${FILESDIR}"/${P}-python3.patch
)

src_prepare() {
	default
	 has_version ">=media-libs/lv2-1.16.0" && (sed -i "s/lv2core/lv2/" wscript || die "Failed to fix lv2")
}

src_configure() {
	waf-utils_src_configure \
		--prefix=/usr \
		--libdir=/usr/$(get_libdir) \
		--htmldir=/usr/share/doc/${PF}/html \
		$(use doc && echo --build-docs) \
		$(use jack || echo --no-jack)
}
