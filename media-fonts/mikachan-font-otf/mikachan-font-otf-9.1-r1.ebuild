# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/mikachan-font-otf/mikachan-font-otf-9.1-r1.ebuild,v 1.9 2010/08/03 16:08:00 ssuominen Exp $

inherit font

DESCRIPTION="Mikachan Japanese TrueType Collection fonts"
HOMEPAGE="http://mikachan-font.com/"
SRC_URI="mirror://gentoo/${P}.tar.bz2
	http://dev.gentoo.org/~flameeyes/dist/${P}.tar.bz2"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""

FONT_SUFFIX="otf"
FONT_S="${WORKDIR}/${P}"

# Only installs fonts
RESTRICT="strip binchecks"

FONT_CONF=( "${FILESDIR}/60-mikachan_o.conf" )
