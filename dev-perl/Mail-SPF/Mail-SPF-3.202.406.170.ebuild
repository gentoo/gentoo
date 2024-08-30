# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MBRADSHAW
DIST_VERSION=3.20240617
inherit perl-module

DESCRIPTION="An object-oriented implementation of Sender Policy Framework"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	dev-perl/Error
	>=dev-perl/Net-DNS-0.620.0
	>=dev-perl/NetAddr-IP-4
	>=dev-perl/URI-1.130.0
	dev-perl/Net-DNS-Resolver-Programmable
	virtual/perl-version
"
# TODO: Mail::SPF::Test for more tests?
BDEPEND="
	${RDEPEND}
	dev-perl/Net-DNS-Resolver-Programmable
	test? ( virtual/perl-Test-Simple )
"

src_prepare() {
	perl-module_src_prepare
	sed -i \
		-e "s:spfquery:spfquery.pl:" \
		-e "s:spfd:spfd.pl:" \
		Makefile.PL || die "sed failed"
	mv "${S}"/bin/spfquery{,.pl} || die "renaming spfquery failed" # bug #281189
	mv "${S}"/bin/spfd{,.pl} || die "renaming spfd failed" # bugs #886179 and #928140
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
