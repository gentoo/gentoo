# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools eutils

DESCRIPTION="Indent program source files"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="
	https://dev.gentoo.org/~jer/${P/_p*/}.tar.gz
	http://http.debian.net/debian/pool/main/i/${PN}/${PN}_${PV/_p*/}-${PV/*_p/}.debian.tar.xz
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="nls"

DEPEND="
	nls? ( sys-devel/gettext )
	app-text/texi2html
"
RDEPEND="
	nls? ( virtual/libintl )
"
PATCHES=(
	"${FILESDIR}"/${P/_p*/}-segfault.patch
	"${FILESDIR}"/${P/_p*/}-texi2html-5.patch
	"${FILESDIR}"/${P/_p*/}-ac_config_headers.patch
	"${FILESDIR}"/${P/_p*/}-linguas.patch
)
S=${WORKDIR}/${P/_p*/}

src_prepare() {
	default

	eapply "${WORKDIR}"/debian/patches/*.patch

	local pofile
	for pofile in po/zh_TW*; do
		mv ${pofile} ${pofile/.Big5} || die
	done

	eautoreconf
}

src_configure() {
	strip-linguas -i po/

	econf $(use_enable nls)
}

src_test() {
	emake -C regression/
}

src_install() {
	# htmldir as set in configure is ignored in doc/Makefile*
	emake DESTDIR="${D}" htmldir="${EPREFIX}/usr/share/doc/${PF}/html" install
	dodoc AUTHORS NEWS README ChangeLog ChangeLog-1990 ChangeLog-1998 ChangeLog-2001
}
