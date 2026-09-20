# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit cmake

DESCRIPTION="Migemo library implementation in C"
HOMEPAGE="https://www.kaoriya.net/software/cmigemo/"
SRC_URI="https://github.com/koron/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~x86"
IUSE="unicode vim"

RDEPEND=">=app-dicts/migemo-dict-200812[unicode=]"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-vim.patch )
DOCS=( doc/README_ja.txt )

src_configure() {
	local mycmakeargs=(
		-DBUILD_DICT=OFF
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	local dat
	if use unicode; then
		for dat in dict/*.dat; do
			cp "${dat}" "${BUILD_DIR}"/${dat##*/} || die
		done
	else
		for dat in dict/*.dat; do
			iconv -f UTF-8 -t EUC-JISX0213 "${dat}" >"${BUILD_DIR}"/${dat##*/} || die
		done
	fi
}

src_install() {
	cmake_src_install
	insinto /usr/share/migemo
	doins "${BUILD_DIR}"/*.dat

	if use vim; then
		insinto /usr/share/vim/vimfiles/plugin
		doins misc/vim/migemo.vim

		insinto /usr/share/vim/vimfiles/doc
		doins misc/vim/vimigemo.txt
	fi
}
