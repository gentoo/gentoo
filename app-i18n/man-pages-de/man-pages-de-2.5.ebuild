# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

MY_P="${PN/-/}-v${PV}"

DESCRIPTION="A somewhat comprehensive collection of Linux german man page translations"
HOMEPAGE="https://salsa.debian.org/manpages-de-team/manpages-de"
SRC_URI="https://salsa.debian.org/manpages-de-team/manpages-de/-/archive/v${PV}/${MY_P}.tar.bz2"

LICENSE="GPL-3+ man-pages GPL-2+ GPL-2 BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

RDEPEND="virtual/man"
DEPEND="app-text/po4a"

S=${WORKDIR}/${MY_P}

src_unpack() {
	default

	# sys-apps/shadow has it's own translated man-page for this
	rm "${S}/upstream/primary/man1/groups.1" || die
	rm "${S}/po/primary/man1/groups.1.po" || die
}

src_prepare() {
	default

	# Use the same compression as every other manpage
	local PORTAGE_COMPRESS_LOCAL=${PORTAGE_COMPRESS-bzip2}
	if [[ ${PORTAGE_COMPRESS+set} == "set" ]] ; then
		PORTAGE_COMPRESS_LOCAL="#"
	fi
	if [[ ${PORTAGE_COMPRESS_FLAGS+set} != "set" ]] ; then
		case ${PORTAGE_COMPRESS_LOCAL} in
			bzip2|gzip)  local PORTAGE_COMPRESS_FLAGS_LOCAL="-9"
			;;
		esac
	fi
	sed -i -e "s/gzip --best/${PORTAGE_COMPRESS_LOCAL} ${PORTAGE_COMPRESS_FLAGS_LOCAL}/"\
		po/Makefile.in || die
	eautoreconf
}

src_compile() { :; }

src_install() {
	emake mandir="${ED}"/usr/share/man install
	dodoc CHANGES.md README.md
}
