# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/tablix/tablix-0.3.5-r1.ebuild,v 1.5 2014/08/10 18:10:36 slyfox Exp $

EAPI="2"
inherit eutils autotools

MY_PV="${PN}2-${PV}"

DESCRIPTION="Tablix is a powerful free software kernel for solving general timetabling problems"
HOMEPAGE="http://www.tablix.org/"
SRC_URI="http://www.tablix.org/releases/stable/${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE="pvm"

DEPEND=">=dev-libs/libxml2-2.4.3
	pvm?	( sys-cluster/pvm )"

S="${WORKDIR}/${MY_PV}"

pkg_setup() {
	if ! use pvm; then
		ewarn
		ewarn "Without parallel virtual machine support, tablix will not be able"
		ewarn "to solve even moderately complex problems.  Even if you are using"
		ewarn "a single machine, USE=pvm is highly recommended."
		ewarn
		epause 5
	fi
}

src_prepare() {
	sed -i "/^localedir/s:/locale:/share/${PN}/locale:" configure.in \
		|| die "sed failed"
	sed -i "/^ACLOCAL_AMFLAGS/s:^:#:" Makefile.am \
		|| die "sed failed"
	eautoreconf
	# fix compilation when no optimizations are enabled wrt bug #240046
	sed -i -e '32 d' -e '34 d' src/master.c || die "sed failed"
	sed -i -e '31 d' -e '33 d' src/main.c || die "sed failed"
	sed -i -e '30 d' -e '32 d' src/output.c || die "sed failed"

}

src_configure() {
	econf \
		$(use_with pvm pvm3) \
		|| die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS BUGS ChangeLog NEWS README
	cd doc
	dodoc manual.pdf modules.pdf modules2.pdf morphix.pdf
}
