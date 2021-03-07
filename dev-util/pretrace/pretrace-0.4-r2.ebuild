# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit readme.gentoo-r1

DESCRIPTION="start dynamically linked applications under debugging environment"
HOMEPAGE="https://github.com/robholland/pretrace"
SRC_URI="https://dev.gentoo.org/~bircoph/distfiles/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

DOC_CONTENTS="Remember to execute ptgenmap after modifying pretrace.conf"

PATCHES=(
	"${FILESDIR}"/${P}--as-needed.diff
	"${FILESDIR}"/${P}-build.patch #227923
	"${FILESDIR}"/${P}-qa.patch
)

src_install() {
	dodir /usr/bin /usr/share/man/man3 /usr/share/man/man8
	emake DESTDIR="${D}" LIBDIR="${D}/usr/$(get_libdir)" PREFIX="${D}/usr" VERSION="${PVR}" install
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
