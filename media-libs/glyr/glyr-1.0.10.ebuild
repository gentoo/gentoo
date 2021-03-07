# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Music related metadata searchengine, both with commandline interface and C API"
HOMEPAGE="https://github.com/sahib/glyr"
SRC_URI="https://github.com/sahib/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	dev-db/sqlite:3
	>=dev-libs/glib-2.10:2
	net-misc/curl
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

DOCS=( AUTHORS README.textile ) # CHANGELOG is obsolete in favour of git history

src_prepare() {
	cmake-utils_src_prepare

	sed -i \
		-e '/GCC_ONLY_OPT.*-s/d' \
		-e '/FLAGS/s:-Os::' \
		-e '/FLAGS/s:-g3::' \
		CMakeLists.txt || die
}
