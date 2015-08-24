# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils multilib

CMAKE_USE_DIR="${S}/cmake"

if [ ${PV} == "9999" ] ; then
	inherit subversion
	ESVN_REPO_URI="https://lz4.googlecode.com/svn/trunk/"
	ESVN_PROJECT="lz4-read-only"
else
	SRC_URI="https://dev.gentoo.org/~ryao/dist/${P}.tar.xz"
	KEYWORDS="~alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh ~sparc x86 ~amd64-linux ~x86-linux"
fi

DESCRIPTION="Extremely Fast Compression algorithm"
HOMEPAGE="https://code.google.com/p/lz4/"

LICENSE="BSD-2"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	if [ ${PV} == "9999" ]
	then
		subversion_src_prepare
	else
		epatch "${FILESDIR}/${P}-install-to-bindir.patch"
		epatch "${FILESDIR}/${P}-cflags.patch"
	fi
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(-DBUILD_SHARED_LIBS=ON)
	cmake-utils_src_configure
}

src_install() {
	dodir /usr
	dodir "/usr/$(get_libdir)"
	ln -s "$(get_libdir)" "${ED}usr/lib" || \
		die "Cannot create temporary symlink from usr/lib to usr/$(get_libdir)"

	cmake-utils_src_install

	rm "${ED}usr/lib"

	if [ -f "${ED}usr/bin/lz4c64" ]
	then
		dosym lz4c64 /usr/bin/lz4c
	else
		dosym lz4c32 /usr/bin/lz4c
	fi
}
