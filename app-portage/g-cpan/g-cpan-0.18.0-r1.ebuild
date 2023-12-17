# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit perl-module

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/gentoo-perl/g-cpan.git"
	inherit git-r3
else
	SRC_URI="https://github.com/gentoo-perl/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86"
fi

DESCRIPTION="Autogenerate and install ebuilds for CPAN modules"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Perl/g-cpan"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	dev-perl/Config-Tiny
	virtual/perl-File-Path
	virtual/perl-File-Spec
	dev-perl/Log-Agent
	virtual/perl-Memoize
	virtual/perl-IO
	dev-perl/Path-Tiny
	dev-perl/Shell-EnvImporter
	virtual/perl-Term-ANSIColor
	>=dev-perl/YAML-0.60
"
RDEPEND="
	${COMMON_DEPEND}
	>=sys-apps/portage-2.0.0
"
BDEPEND="
	${COMMON_DEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( >=virtual/perl-Test-Simple-0.940.0 )
"

src_install() {
	perl-module_src_install

	if ! use prefix; then
		diropts -m0775 -o portage -g portage
	else
		diropts -m0775
	fi

	dodir /var/tmp/g-cpan
	dodir /var/log/g-cpan
	keepdir /var/log/g-cpan
}

pkg_preinst() {
	has_version "<app-portage/g-cpan-0.18.0-r1" && HAD_EAPI5_GCPAN=1
}

pkg_postinst() {
	if [[ ${HAD_EAPI5_GCPAN:-0} -eq 1 ]] ; then
		ewarn "Please re-create your overlay with generated g-cpan ebuilds!"
		ewarn "The old ebuilds will use EAPI 5 and be incompatible with newer"
		ewarn "Perl eclass changes. This newer version of g-cpan (0.18.0+)"
		ewarn "generates EAPI 8 ebuilds without this problem, but it cannot"
		ewarn "change existing ebuilds. See bug #819513."
	fi

	elog "If you want to use g-cpan as non root user you may wish to adjust"
	elog "the permissions on /var/tmp/g-cpan or add users to the portage group."
	elog "Please note that some CPAN packages need additional manual"
	elog "parameters or tweaking, due to bugs in their build systems."
}
