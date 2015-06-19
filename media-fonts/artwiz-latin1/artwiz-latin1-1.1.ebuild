# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/artwiz-latin1/artwiz-latin1-1.1.ebuild,v 1.15 2009/02/27 22:53:16 jer Exp $

inherit font

DESCRIPTION="A set of improved Artwiz fonts with bold and full ISO-8859-1 support"
HOMEPAGE="http://artwiz-latin1.sourceforge.net/"
SRC_URI="mirror://sourceforge/artwiz-latin1/${P}.tgz"

LICENSE="GPL-2"
SLOT=0
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""

S=${WORKDIR}/artwiz-latin1
FONT_S=${S}
FONT_SUFFIX="pcf.gz"
DOCS="README AUTHORS VERSION CHANGELOG"
