# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Tidy the layout and correct errors in HTML, HTML5 and XML documents"
HOMEPAGE="http://www.html-tidy.org/"
SRC_URI="https://github.com/htacg/${PN}/archive/${PV}.zip -> ${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"

RDEPEND="!app-text/htmltidy"

DOCS=( README/{CODESTYLE,CONTRIBUTING,LICENSE,VERSION}.md )

BUILD_DIR="${S}/build/cmake"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=/usr
		-DCMAKE_BUILD_TYPE=Release
	)

	cmake-utils_src_configure
}

src_compile() {
	cd build/cmake || die
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
}
