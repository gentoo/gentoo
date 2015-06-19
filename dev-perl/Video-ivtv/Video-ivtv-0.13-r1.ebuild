# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Video-ivtv/Video-ivtv-0.13-r1.ebuild,v 1.5 2014/03/05 15:30:30 ago Exp $

EAPI=5

inherit perl-module

DESCRIPTION="Video::ivtv perl module, for use with ivtv-ptune"
HOMEPAGE="http://ivtv.sourceforge.net"
SRC_URI="mirror://sourceforge/ivtv/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ia64 ppc x86"
IUSE=""

export OPTIMIZE="$CFLAGS"

RDEPEND="${DEPEND}"
