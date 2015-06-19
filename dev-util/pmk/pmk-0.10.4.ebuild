# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/pmk/pmk-0.10.4.ebuild,v 1.4 2010/09/13 01:57:45 mr_bones_ Exp $

EAPI=3

inherit toolchain-funcs

DESCRIPTION="Aims to be an alternative to GNU autoconf"
HOMEPAGE="http://pmk.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-linux ~ppc-macos"
IUSE=""

DEPEND=""
RDEPEND=""

src_prepare() {
	# Make this respect LDFLAGS, bug #334987
	sed -i -e "s:CLDFLAGS:LDFLAGS:" Makefile.pmk || die
	sed -i -e "/@CLDFLAGS@/d" Makefile.pmk || die

	# Remove executable stack
	cp detect_cpu_asm.s detect_cpu_asm.S
	cat >> detect_cpu_asm.S <<EOF
#ifdef __ELF__
.section .note.GNU-stack,"",%progbits
#endif
EOF
}

src_configure() {
	tc-export CC CPP AS
	export SYSCONFDIR="${EPREFIX}"/etc
	export PREFIX="${EPREFIX}"/usr
	./pmkcfg.sh autodetected || die "Config failed"
}

src_install () {
	emake -j1 DESTDIR="${D}" MANDIR="${EPREFIX}/usr/share/man" install || die "make failed"

	dodoc BUGS Changelog README STATUS TODO || die "dodoc failed"
}

pkg_postinst() {
	if [[ ! -f ${EROOT}etc/pmk/pmk.conf ]] ; then
		einfo
		einfo "${EROOT}etc/pmk/pmk.conf doesn't exist."
		einfo "Running pmksetup to generate an initial pmk.conf."
		einfo
		# create one with initial values
		"${EROOT}"usr/bin/pmksetup
		# run it again to reset PREFIX from /usr/local to ${EPREFIX}/usr
		"${EROOT}"usr/bin/pmksetup -u "PREFIX=\"${EPREFIX}/usr\""
		# remove the automatically created backup from the extra run
		rm -f "${EROOT}"etc/pmk/pmk.conf.bak
	fi
}
