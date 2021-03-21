# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="ttf-${P}"
inherit font

DESCRIPTION="Replacement fonts for Microsoft's Arial, Times, and Verdana fonts"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage" # upstream vanished
SRC_URI="mirror://gentoo/${MY_P}.tgz"
S="${WORKDIR}/${MY_P}"

LICENSE="BitstreamVera"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~ppc ppc64 s390 sparc x86"
IUSE=""

DOCS=( CHANGELOG.TXT local.conf.arkpandora )

FONT_SUFFIX="ttf"
