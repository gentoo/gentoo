# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit readme.gentoo-r1

DESCRIPTION="Excellent program to automatically configure PPP sessions"
HOMEPAGE="https://code.google.com/archive/p/wvstreams/"
SRC_URI="https://wvstreams.googlecode.com/files/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~sparc ~x86"

DEPEND=">=net-libs/wvstreams-4.4"
RDEPEND="${DEPEND}
	net-dialup/ppp:=
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}-destdir.patch"
	"${FILESDIR}/${P}-as-needed.patch"
	"${FILESDIR}/${P}-parallel-make.patch"
)

DOC_CONTENTS="
	Use wvdialconf to automagically generate a configuration file.
	Users have to be member of the dialout AND the uucp group to use
	wvdial
"

src_configure() {
	# Hand made configure...
	./configure || die
}

src_install() {
	default
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
