# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="getopt(1) replacement supporting GNU-style long options"
HOMEPAGE="http://frodo.looijaard.name/project/getopt/"
SRC_URI="http://frodo.looijaard.name/system/files/software/getopt/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~arm64-macos ~x64-macos ~x64-solaris"
IUSE="nls"

RDEPEND="nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.5-libintl.patch
	"${FILESDIR}"/${PN}-1.1.5-setlocale.patch
	"${FILESDIR}"/${PN}-1.1.6-longrename.patch
	"${FILESDIR}"/${PN}-1.1.4-irix.patch
)

src_compile() {
	local nogettext="1"
	local libintl=""
	local libcgetopt=1

	if use nls; then
		nogettext=0
		has_version sys-libs/glibc || libintl="-lintl"
	fi

	emake CC="$(tc-getCC)" prefix="${EPREFIX}/usr" \
		LIBCGETOPT=${libcgetopt} \
		WITHOUT_GETTEXT=${nogettext} LIBINTL=${libintl} \
		CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	use nls && emake prefix="${EPREFIX}/usr" DESTDIR="${D}" install_po

	newbin getopt getopt-long

	newman getopt.1 getopt-long.1

	dodoc getopt-*sh
}
