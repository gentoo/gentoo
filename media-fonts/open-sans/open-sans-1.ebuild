# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/open-sans/open-sans-1.ebuild,v 1.2 2015/04/28 10:01:38 yngwin Exp $

EAPI=5
inherit font

DESCRIPTION="A clean and modern sans-serif typeface designed for legibility across interfaces"
HOMEPAGE="http://www.opensans.com/"
SRC_URI="http://dev.gentoo.org/~yngwin/distfiles/${P}.zip"
# renamed from unversioned google zip

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE=""

DEPEND="app-arch/unzip"
S=${WORKDIR}
FONT_SUFFIX="ttf"
