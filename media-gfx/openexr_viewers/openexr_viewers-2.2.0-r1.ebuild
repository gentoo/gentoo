# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools flag-o-matic

DESCRIPTION="OpenEXR Viewers"
HOMEPAGE="https://openexr.com"
SRC_URI="https://download.savannah.gnu.org/releases/openexr/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="cg opengl"

RDEPEND="~media-libs/ilmbase-${PV}:=
	~media-libs/openexr-${PV}:=
	>=media-libs/ctl-1.5.2:=
	x11-libs/fltk:1[opengl]
	opengl? (
		virtual/opengl
		x11-libs/fltk:1[opengl]
		cg? ( media-gfx/nvidia-cg-toolkit )
	)"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}/${P}-Remove-nVidia-automagic.patch" )

src_prepare() {
	default
	sed -i -e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' configure.ac || die
	eautoreconf
}

src_configure() {
	local myconf

	if use cg; then
		myconf="--with-cg-prefix=/opt/nvidia-cg-toolkit"
		append-flags "$(no-as-needed)" # binary-only libCg is not properly linked
	fi

	econf \
		$(use_enable cg) \
		$(use_with opengl fltk-config /usr/bin/fltk-config) \
		${myconf}
}

src_install() {
	emake \
		DESTDIR="${D}" \
		docdir=/usr/share/doc/${PF}/pdf \
		install

	dodoc AUTHORS ChangeLog NEWS README
}
