# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/openexr_viewers/openexr_viewers-2.2.0.ebuild,v 1.2 2015/08/06 16:44:50 klausman Exp $

EAPI=5
inherit autotools eutils flag-o-matic

DESCRIPTION="OpenEXR Viewers"
HOMEPAGE="http://openexr.com/"
SRC_URI="http://download.savannah.gnu.org/releases/openexr/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="cg opengl"

RDEPEND=">=media-libs/ilmbase-${PV}:=
	>=media-libs/openexr-${PV}:=
	media-libs/ctl:=
	>=media-libs/openexr_ctl-1.0.1-r2:=
	opengl? (
		virtual/opengl
		x11-libs/fltk:1[opengl]
		cg? ( media-gfx/nvidia-cg-toolkit )
		)"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	sed -i -e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' configure.ac || die
	epatch "${FILESDIR}"/${PN}-2.0.0-nvidia-automagic.patch
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
