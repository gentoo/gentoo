# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MISHIKAL
DIST_EXAMPLES=( "examples/*" )
inherit multilib perl-module

DESCRIPTION="Perl5 Module Supporting LDAP API"
HOMEPAGE="https://sourceforge.net/projects/net-ldapapi/
	http://search.cpan.org/~mishikal/Net-LDAPapi/"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
# LICENSE is given on the corresponding sourceforge project and matches the
# default cpan/perl license

RDEPEND="net-nds/openldap[sasl]
	dev-libs/cyrus-sasl
	>=dev-perl/Convert-ASN1-0.190.0"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker"

PATCHES=(
	"${FILESDIR}/${P}-ldap_result-no_error.patch"
	"${FILESDIR}/${P}-test-env.patch"
)

src_configure() {
	myconf="-sdk OpenLDAP -lib_path /usr/$(get_libdir) -include_path /usr/include"
	perl-module_src_configure
}

src_install() {
	mydoc="Credits Todo"
	perl-module_src_install
}

src_test() {
	local MODULES=(
		"Net::LDAPapi ${DIST_VERSION}"
	)
	local failed=()
	for dep in "${MODULES[@]}"; do
		ebegin "Compile testing ${dep}"
			perl -Mblib="${S}" -M"${dep} ()" -e1
		eend $? || failed+=( "$dep" )
	done
	if [[ ${failed[@]} ]]; then
		echo
		eerror "One or more modules failed compile:";
		for dep in "${failed[@]}"; do
			eerror "  ${dep}"
		done
		die "Failing due to module compilation errors";
	fi
	if [[ -n "${LDAP_TEST_HOST}" ]]; then
		perl-module_src_test
	else
		elog "Comprehensive testing disabled without LDAP_TEST_HOST set. For details, see:"
		elog "https://wiki.gentoo.org/wiki/Project:Perl/maint-notes/${CATEGORY}/${PN}"
	fi
}
