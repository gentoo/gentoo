# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Erlang-style concurrency for Gambit Scheme"
HOMEPAGE="https://code.google.com/p/termite/"
SRC_URI="https://termite.googlecode.com/files/${PN}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-scheme/gambit"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_install() {
	dobin tsi
	dodoc README CHANGELOG

	insinto /usr/$(get_libdir)/${PN}/
	doins *.scm
	doins -r otp

	insinto /usr/share/${PN}
	doins -r examples test benchmarks
}
