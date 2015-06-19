# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/wqy-bitmapfont/wqy-bitmapfont-1.0.0_rc1.ebuild,v 1.6 2014/06/10 07:22:55 zlogene Exp $

inherit font

MY_PN="wqy-bitmapsong"
DESCRIPTION="WenQuanYi Bitmap Song CJK font"
HOMEPAGE="http://wenq.org/wqy2/index.cgi?Home"
SRC_URI="mirror://sourceforge/wqy/${MY_PN}-pcf-${PV/_rc/-RC}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ~s390 ~sh sparc x86 ~x86-fbsd"
IUSE=""

DEPEND=""

S=${WORKDIR}/${MY_PN}
FONT_S=${S}
FONT_CONF=( "85-wqy-bitmapsong.conf" )

FONT_SUFFIX="pcf"
DOCS="AUTHORS ChangeLog README"

# Only installs fonts
RESTRICT="strip binchecks"
