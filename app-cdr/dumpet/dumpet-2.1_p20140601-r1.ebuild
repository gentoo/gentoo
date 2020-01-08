# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vcs-snapshot

COMMIT="8f47670dd582c96ad1b6dd3c9b9da0acebded5d8"

DESCRIPTION="A tool to dump and debug bootable CD-like images"
HOMEPAGE="https://github.com/rhboot/dumpet"
SRC_URI="https://github.com/rhboot/dumpet/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
#Restrict tests since required test file is unavailable
RESTRICT="test"

RDEPEND="dev-libs/libxml2
	dev-libs/popt"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( dev-util/valgrind )"

src_prepare() {
	sed -i Makefile \
		-e "s/^install : all$/install :/" \
		-e "s/^CFLAGS:=/CFLAGS?=/" \
		-e "s/^CC:=/CC?=/" \
		|| die
	default
}

src_compile() {
	emake CFLAGS="${CFLAGS}" dumpet
}

pkg_setup(){
	tc-export CC
}
