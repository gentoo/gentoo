# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit perl-module
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/gentoo-perl/g-cpan.git"
	inherit git-r3
	SRC_URI=""
else
	SRC_URI="https://github.com/gentoo-perl/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86"
fi

DESCRIPTION="Autogenerate and install ebuilds for CPAN modules"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Perl/g-cpan"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

COMMONDEPEND="
	virtual/perl-File-Path
	virtual/perl-File-Spec
	dev-perl/Log-Agent
	virtual/perl-Memoize
	virtual/perl-IO
	dev-perl/Shell-EnvImporter
	virtual/perl-Term-ANSIColor
	>=dev-perl/YAML-0.60
"
RDEPEND="${COMMONDEPEND}
	>=sys-apps/portage-2.0.0
"
DEPEND="${COMMONDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( >=virtual/perl-Test-Simple-0.940.0 )
"

src_install() {
	perl-module_src_install
	diropts -m0775 -o portage -g portage
	dodir "/var/tmp/g-cpan"
	dodir "/var/log/g-cpan"
	keepdir "/var/log/g-cpan"
}

pkg_postinst() {
	elog "If you want to use g-cpan as non root user you may wish to adjust"
	elog "the permissions on /var/tmp/g-cpan or add users to the portage group."
	elog "Please note that some CPAN packages need additional manual"
	elog "parameters or tweaking, due to bugs in their build systems."
}
