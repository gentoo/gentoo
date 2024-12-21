# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="command line tool to clean and optimize Matroska files"
HOMEPAGE="https://www.matroska.org/downloads/mkclean.html"
SRC_URI="https://downloads.sourceforge.net/project/matroska/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="dev-build/cmake"
# just for makefile generation, using the eclass just complicates things

src_configure() {
	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/861134
	# https://github.com/Matroska-Org/foundation-source/issues/145
	#
	# Do not trust with LTO either.
	append-flags -fno-strict-aliasing
	filter-lto

	tc-export CC CXX

	cmake . || die "Generating makefiles failed"
}

src_install() {
	dobin "${S}"/${PN}/mk{,WD}clean
	newdoc ChangeLog.txt ChangeLog
	newdoc ReadMe.txt README
}
