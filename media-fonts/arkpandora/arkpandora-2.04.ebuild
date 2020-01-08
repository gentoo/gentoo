# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit font

MY_P="ttf-${P}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Arkpandora MS-TTF replacement font pack"
HOMEPAGE="https://www.gentoo.org/" # upstream vanished
SRC_URI="mirror://gentoo/${MY_P}.tgz"

LICENSE="BitstreamVera"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~ppc ppc64 s390 sh sparc x86"
IUSE=""

FONT_S="${S}"
FONT_SUFFIX="ttf"
DOCS="CHANGELOG.TXT local.conf.arkpandora"
