# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils apache-module

DESCRIPTION="mod_flvx allows to seek inside FLV files for streaming purposes"
HOMEPAGE="http://journal.paul.querna.org/articles/2006/07/11/mod_flvx/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

APACHE2_MOD_CONF="20_${PN}"
APACHE2_MOD_DEFINE="FLVX"

need_apache2
