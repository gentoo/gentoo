# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-calculators/orpie/orpie-1.5.1-r1.ebuild,v 1.7 2014/11/13 12:55:45 jer Exp $

EAPI=4
inherit eutils autotools

DESCRIPTION="A fullscreen RPN calculator for the console"
HOMEPAGE="http://pessimization.com/software/orpie/"
SRC_URI="http://pessimization.com/software/${PN}/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux"
IUSE="doc"

DEPEND="dev-ml/ocamlgsl
	sys-libs/ncurses"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-ocaml311.patch
	epatch "${FILESDIR}"/${P}-nogsl.patch
	epatch "${FILESDIR}"/${P}-orpierc.patch
	epatch "${FILESDIR}"/${P}-tinfo.patch
	sed -i -e "s:/usr:${EPREFIX}/usr:g" Makefile.in || die
	eautoreconf
}

src_install() {
	default
	use doc && dodoc doc/manual.pdf && dohtml doc/manual.html
}
