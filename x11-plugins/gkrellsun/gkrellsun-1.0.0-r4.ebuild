# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit gkrellm-plugin

DESCRIPTION="A GKrellM plugin that shows sunrise and sunset times"
HOMEPAGE="http://gkrellsun.sourceforge.net/"
SRC_URI="mirror://sourceforge/gkrellsun/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="1"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~sparc ~x86"
IUSE="nls"

COMMON_DEPEND="app-admin/gkrellm[X]
	nls? ( sys-devel/gettext )"
DEPEND+=" ${COMMON_DEPEND}"
RDEPEND+=" ${COMMON_DEPEND}"

PLUGIN_SO=src20/gkrellsun.so

PATCHES=(
	"${FILESDIR}/${P}-reenable.patch"
	"${FILESDIR}/${P}-Respect-LDFLAGS.patch"
)

src_compile() {
	use nls && myconf="$myconf enable_nls=1"
	emake ${myconf}
}
