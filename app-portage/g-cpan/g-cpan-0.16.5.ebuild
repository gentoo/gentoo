# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit perl-module

DESCRIPTION="g-cpan: generate and install CPAN modules using portage"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Perl/g-cpan"
SRC_URI="mirror://gentoo/${P}.tar.gz
		 https://dev.gentoo.org/~chainsaw/distfiles/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86"
IUSE=""

DEPEND="dev-lang/perl
		>=dev-perl/YAML-0.60
		dev-perl/Shell-EnvImporter
		dev-perl/Log-Agent"
RDEPEND="${DEPEND}"

src_install() {
		perl-module_src_install
		diropts "-m0755"
		dodir "/var/tmp/g-cpan"
		keepdir "/var/tmp/g-cpan"
		dodir "/var/log/g-cpan"
		keepdir "/var/log/g-cpan"
}

pkg_postinst() {
	elog "You may wish to adjust the permissions on /var/tmp/g-cpan"
	elog "if you have users besides root expecting to use g-cpan."
	elog "Please note that some CPAN packages need additional manual"
	elog "parameters or tweaking, due to bugs in their build systems."
}
