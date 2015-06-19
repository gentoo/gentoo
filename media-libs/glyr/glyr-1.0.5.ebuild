# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/glyr/glyr-1.0.5.ebuild,v 1.3 2014/04/20 08:50:10 ago Exp $

EAPI=5
inherit cmake-utils

DESCRIPTION="A music related metadata searchengine, both with commandline interface and C API"
HOMEPAGE="http://github.com/sahib/glyr"
SRC_URI="https://github.com/sahib/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-db/sqlite:3
	>=dev-libs/glib-2.10:2
	net-misc/curl"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS="AUTHORS README*" # CHANGELOG is obsolete in favour of git history

src_prepare() {
	sed -i \
		-e '/GCC_ONLY_OPT.*-s/d' \
		-e '/FLAGS/s:-Os::' \
		-e '/FLAGS/s:-g3::' \
		CMakeLists.txt || die
}
