# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=2

inherit eutils bash-completion-r1

DESCRIPTION="Script for unpacking various file formats"
HOMEPAGE="https://packages.qa.debian.org/u/unp.html"
SRC_URI="mirror://debian/pool/main/u/unp/${PN}_${PV/_/$'\x7e'}.tar.bz2"
S="${WORKDIR}/${PN}-${PV/_/$'\x7e'}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="nls"

DEPEND="nls? ( sys-devel/gettext )"

RDEPEND="${DEPEND}
	dev-lang/perl"

src_compile() {
	if use nls; then
		cd po
		emake
	fi
}

src_install() {
	dobin unp || die "dobin failed"
	dosym unp /usr/bin/ucat
	doman debian/unp.1 || die "doman failed"
	dodoc debian/changelog debian/README.Debian
	dobashcomp bash_completion.d/unp

	if use nls; then
		cd po
		emake DESTDIR="${D}" install
	fi
}
