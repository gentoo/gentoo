# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=JMEHNLE
DIST_SECTION=mail-spf
DIST_VERSION=v2.9.0
inherit perl-module

DESCRIPTION="An object-oriented implementation of Sender Policy Framework"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sparc x86 ~x86-fbsd"
IUSE="test"

RDEPEND="
	dev-perl/Error
	>=dev-perl/Net-DNS-0.620.0
	>=dev-perl/NetAddr-IP-4
	>=dev-perl/URI-1.130.0
	>=dev-perl/Net-DNS-Resolver-Programmable-0.3.0
	virtual/perl-version
	!!dev-perl/Mail-SPF-Query
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.280.500
	>=dev-perl/Net-DNS-Resolver-Programmable-0.3.0
	test? ( virtual/perl-Test-Simple )
"

src_prepare() {
	perl-module_src_prepare
	sed -i -e "s:spfquery:spfquery.pl:" Build.PL || die "sed failed"
	mv "${S}"/bin/spfquery "${S}"/bin/spfquery.pl || die "renaming spfquery failed"
}

pkg_postinst() {
	elog "The spfquery script was renamed to spfquery.pl because of file collisions."
}

src_test() {
	local badfiles=(
		t/90-author-pod-validation.t
	)
	if ! has network ${DIST_TEST_OVERRIDE:-${DIST_TEST:-do parallel}}; then
		einfo "Removing network tests w/o DIST_TEST_OVERRIDE=~network"
		badfiles+=( "t/00.04-class-server.t" )
	fi
	perl_rm_files "${badfiles[@]}"
	perl-module_src_test
}
