# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="parses logfiles of a wide variety of web proxy servers and generates reports"
HOMEPAGE="https://cord.de/calamaris-english"
SRC_URI="https://cord.de/files/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="selinux"

RDEPEND="
	dev-lang/perl
	dev-perl/GDGraph
	selinux? ( sec-policy/selinux-calamaris )
"

src_prepare() {
	default
	sed -i \
		-e "s:\(use lib\).*$:\1 '/usr/share/';:" \
		calamaris || die
}

src_install() {
	dobin calamaris calamaris-cache-convert

	insinto /usr/share/${PN}
	doins *.pm

	doman calamaris.1

	dodoc BUGS CHANGES EXAMPLES EXAMPLES.v3 README TODO calamaris.conf
}
