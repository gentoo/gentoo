# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

DESCRIPTION="A Perl script that removes spam from POP3 mailboxes based on RBLs"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="https://fossies.org/linux/privat/old/${P}.tar.gz"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="alpha ~amd64 ~hppa ~mips ppc sparc x86"
IUSE=""

DEPEND=">=dev-lang/perl-5.6.1
	>=virtual/perl-libnet-1.11
	>=sys-apps/sed-4
	>=dev-perl/Net-DNS-0.12"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	#This doesnt look neat but makes it work
	sed -i \
		-e 's/\/usr\/local\/bin\/perl/\/usr\/bin\/perl/' disspam.pl || \
			die "sed disspam.pl failed"
}

src_install() {
	dobin disspam.pl
	dodoc changes.txt configuration.txt readme.txt sample.conf
}
