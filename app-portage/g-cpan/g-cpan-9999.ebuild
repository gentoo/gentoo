# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit perl-module
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://github.com/gentoo-perl/g-cpan.git"
	inherit git-r3
	SRC_URI=""
else
	SRC_URI="https://dev.gentoo.org/~dilfridge/distfiles/${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
fi

DESCRIPTION="g-cpan: generate and install CPAN modules using portage"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Perl/g-cpan"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
IUSE=""

DEPEND="
	>=dev-perl/yaml-0.60
	>=dev-perl/Shell-EnvImporter-1.70.0-r2
	dev-perl/Log-Agent
"
RDEPEND="${DEPEND}
	>=sys-apps/portage-2.0.0
"

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
