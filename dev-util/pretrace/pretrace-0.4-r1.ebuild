# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit readme.gentoo-r1

DESCRIPTION="start dynamically linked applications under debugging environment"
HOMEPAGE="http://dev.inversepath.com/trac/pretrace"
SRC_URI="http://dev.inversepath.com/pretrace/libpretrace-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

S="${WORKDIR}/lib${P}"

DOC_CONTENTS="Remember to execute ptgenmap after modifying pretrace.conf"

PATCHES=(
	"${FILESDIR}"/${P}--as-needed.diff
	"${FILESDIR}"/${P}-build.patch #227923
)

src_install() {
	dodir /usr/bin /usr/share/man/man3 /usr/share/man/man8
	emake DESTDIR="${D}" LIBDIR="${D}/usr/$(get_libdir)" PREFIX="${D}/usr" install
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
