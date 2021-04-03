# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="getopt(1) replacement supporting GNU-style long options"
HOMEPAGE="http://frodo.looijaard.name/project/getopt/"
SRC_URI="http://frodo.looijaard.name/system/files/software/getopt/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~x64-cygwin ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
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

	[[ ${CHOST} == *-aix* ]] && libcgetopt=0
	[[ ${CHOST} == *-irix* ]] && libcgetopt=0
	[[ ${CHOST} == *-interix* ]] && libcgetopt=0

	emake CC="$(tc-getCC)" prefix="${EPREFIX}/usr" \
		LIBCGETOPT=${libcgetopt} \
		WITHOUT_GETTEXT=${nogettext} LIBINTL=${libintl} \
		CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	use nls && emake prefix="${EPREFIX}/usr" DESTDIR="${D}" install_po

	newbin getopt getopt-long

	# at least on interix, the system getopt is ... broken...
	# util-linux, which would provide the getopt binary, does not build &
	# install on interix/prefix, so, this has to provide it.
	[[ ${CHOST} == *-interix* || ${CHOST} == *-mint* ]] && \
		dosym getopt-long /usr/bin/getopt

	newman getopt.1 getopt-long.1

	dodoc getopt-*sh
}
