# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-multilib

DESCRIPTION="A wrapper to fake privilege separation"
HOMEPAGE="https://cwrap.org/uid_wrapper.html"
SRC_URI="https://www.samba.org/ftp/pub/cwrap/${P}.tar.gz
	https://ftp.samba.org/pub/cwrap/${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND=""
RDEPEND="${DEPEND}"

# https://bugs.gentoo.org/578668
SRC_URI+=" https://git.samba.org/?p=uid_wrapper.git;a=blobdiff_plain;f=src/uid_wrapper.c;h=ded857a1b18f4744bac324b0ccaee3b2d2d146fa;hp=34889e0c3f955ad04bda3859b734a86763dee529;hb=cf2b35344d4de927f158a1e6d5b6bbc1be2ffd96;hpb=a00a6b8b300b7baa867191e2bc016b835cf8d1b3 -> ${PN}-1.2.1-alpha_fix.patch"
PATCHES=(
	"${DISTDIR}/${P}-alpha_fix.patch"
)

# Work around a problem with >=dev-util/cmake-3.3.0 (bug #558340)
# Because of this we cannot use cmake-multilib_src_configure() here.
multilib_src_configure() {
	local mycmakeargs=( -DCMAKE_LIBRARY_PATH=/usr/$(get_libdir) )
	cmake-utils_src_configure
}
