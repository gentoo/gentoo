# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit perl-module

DESCRIPTION="Simple log watcher"
HOMEPAGE="https://sourceforge.net/projects/swatch/"
SRC_URI="mirror://sourceforge/swatch/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="dev-perl/Date-Manip
		dev-perl/Date-Calc
		dev-perl/File-Tail
		dev-perl/TimeDate
		>=virtual/perl-Time-HiRes-1.12
		!app-admin/swatch"

src_install() {
	emake install
	newinitd "${FILESDIR}/${PN}-init" "${PN}"
	newconfd "${FILESDIR}/${PN}-confd" "${PN}"
	insinto /etc
	doins "${FILESDIR}/${PN}rc"

	# Clean up perl localpod and packlist (bug #620886)
	perl_delete_localpod
	perl_fix_packlist
}
