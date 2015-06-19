# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/soxr/soxr-0.1.1.ebuild,v 1.15 2014/06/08 13:01:51 ago Exp $

EAPI=5

inherit cmake-multilib

MY_P=${P}-Source
DESCRIPTION="The SoX Resampler library"
HOMEPAGE="https://sourceforge.net/p/soxr/wiki/Home/"
SRC_URI="mirror://sourceforge/soxr/${MY_P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-fbsd"
IUSE="examples"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"
DOCS=( "README" "TODO" "NEWS" "AUTHORS" )
PATCHES=(
	"${FILESDIR}/nodoc.patch"
	"${FILESDIR}/noexamples.patch"
	)

src_install() {
	cmake-multilib_src_install
	if use examples ; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
