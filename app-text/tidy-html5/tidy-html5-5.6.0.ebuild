# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Tidy the layout and correct errors in HTML, HTML5 and XML documents"
HOMEPAGE="http://www.html-tidy.org/"
SRC_URI="https://github.com/htacg/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86"

RDEPEND="!app-text/htmltidy"

DOCS=( README/{CODESTYLE,CONTRIBUTING,LICENSE,VERSION}.md )

src_configure() {
	local mycmakeargs=(
		-DLIB_INSTALL_DIR="$(get_libdir)"
	)
	cmake-utils_src_configure
}
