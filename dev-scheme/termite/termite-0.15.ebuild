# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

inherit multilib

DESCRIPTION="Erlang-style concurrency for Gambit Scheme"
HOMEPAGE="https://code.google.com/p/termite/"
SRC_URI="https://termite.googlecode.com/files/${PN}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="dev-scheme/gambit"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_install() {
	dobin tsi || die "dobin failed"
	dodoc README CHANGELOG || die "dodoc failed"

	insinto /usr/$(get_libdir)/${PN}/
	doins *.scm || die "doins failed"
	doins -r otp || die "doins failed"

	insinto /usr/share/${PN}
	doins -r examples test benchmarks || die "doins failed"
}
