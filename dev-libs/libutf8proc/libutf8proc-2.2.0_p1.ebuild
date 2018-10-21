# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NETSURF_BUILDSYSTEM=buildsystem-1.7
inherit netsurf

DESCRIPTION="mapping tool for UTF-8 strings"
HOMEPAGE="http://www.netsurf-browser.org/"
SRC_URI="${NETSURF_BUILDSYSTEM_SRC_URI}
	http://download.netsurf-browser.org/libs/releases/${P/_p/-}-src.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P/_p/-}"

src_prepare() {
	# working around broken netsurf eclass
	default
	multilib_copy_sources
}
