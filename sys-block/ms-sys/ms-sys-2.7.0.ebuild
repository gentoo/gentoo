# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A command-line program for writing Microsoft compatible boot records"
HOMEPAGE="http://ms-sys.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="sys-devel/gettext"
RDEPEND="virtual/libintl"

src_prepare() {
	default
	# don't compress man-pages by default
	sed '/gzip --no-name -f/d' -i Makefile || die
}

src_compile() {
	tc-export CC
	default
}

src_install() {
	local nls=""
	if ! has sv ${LINGUAS-sv} ; then
		nls='NLS_FILES='
	fi

	emake DESTDIR="${D}" MANDIR="/usr/share/man" \
		PREFIX="/usr" ${nls} install

	dodoc CHANGELOG CONTRIBUTORS FAQ README TODO
}
