# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils bash-completion-r1

DESCRIPTION="Script for unpacking various file formats"
HOMEPAGE="https://packages.qa.debian.org/u/unp.html"
TEMP_PV="${PV/_pre/$'\x7e'pre}"
MY_PV="${TEMP_PV/_p/+nmu}"
SRC_URI="mirror://debian/pool/main/u/unp/${PN}_${MY_PV}.tar.bz2"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="nls"

DEPEND="nls? ( sys-devel/gettext )"

RDEPEND="${DEPEND}
	dev-lang/perl"

PATCHES=( "${FILESDIR}/${P}-remove-deprecated-have.diff" )

src_compile() {
	if use nls; then
		strip-linguas -i .
		if [ -n "$LINGUAS" ]; then
			emake -C po MOFILES="${LINGUAS// /.po }.po"
		else
			emake -C po
		fi
	fi
}

src_install() {
	dobin unp
	dosym unp /usr/bin/ucat
	doman debian/unp.1
	dodoc debian/changelog debian/README.Debian
	dobashcomp bash_completion.d/unp

	if use nls; then
		if [ -n "$LINGUAS" ]; then
			emake -C po MOFILES="${LINGUAS// /.mo }.mo" DESTDIR="${D}" install
		else
			emake -C po DESTDIR="${D}" install
		fi
	fi
}
