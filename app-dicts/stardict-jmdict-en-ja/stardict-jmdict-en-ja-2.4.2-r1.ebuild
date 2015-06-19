# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/stardict-jmdict-en-ja/stardict-jmdict-en-ja-2.4.2-r1.ebuild,v 1.6 2012/03/19 05:33:54 naota Exp $

FROM_LANG="English"
TO_LANG="Japanese"
DICT_PREFIX="jmdict-"

inherit stardict

HOMEPAGE="http://stardict.sourceforge.net/Dictionaries_ja.php"
SRC_URI="mirror://sourceforge/stardict/${P}.tar.bz2"

LICENSE="GDLS"
KEYWORDS="~amd64 ~ppc sparc x86"
IUSE=""

DEPEND=""
RDEPEND=""
