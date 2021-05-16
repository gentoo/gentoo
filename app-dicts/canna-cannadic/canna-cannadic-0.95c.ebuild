# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cannadic

MY_P="${P/canna-/}"

DESCRIPTION="Japanese dictionary as a supplement/replacement to Canna3.5b2"
#HOMEPAGE="http://cannadic.oucrc.org/"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ppc64 sparc x86"
IUSE=""

DEPEND="app-i18n/canna"
S="${WORKDIR}/${MY_P}"

CANNADICS="gcanna gcannaf"
DICSDIRFILE="${FILESDIR}/05cannadic.dics.dir"

src_compile() {
	emake maindic
}
