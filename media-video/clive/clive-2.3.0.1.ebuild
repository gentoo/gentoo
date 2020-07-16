# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
GENTOO_DEPEND_ON_PERL_SUBSLOT=no
inherit perl-module

DESCRIPTION="Command line tool for extracting videos from various websites"
HOMEPAGE="http://clive.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PV:0:3}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="clipboard pager password test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-perl/BerkeleyDB-0.34
	>=dev-perl/Config-Tiny-2.12
	>=virtual/perl-Digest-SHA-5.47
	>=dev-perl/HTML-TokeParser-Simple-2.37
	>=dev-perl/Class-Singleton-1.4
	>=dev-perl/WWW-Curl-4.05
	>=dev-perl/XML-Simple-2.18
	>=dev-perl/Getopt-ArgvFile-1.11
	dev-perl/JSON-XS
	dev-perl/URI
	virtual/perl-Getopt-Long
	virtual/perl-File-Spec
	clipboard? ( >=dev-perl/Clipboard-0.09 )
	pager? ( >=dev-perl/IO-Pager-0.05 )
	password? ( >=dev-perl/Expect-1.21 )
	media-libs/quvi
	|| ( net-misc/wget net-misc/curl )"
DEPEND="test? ( dev-perl/Test-Pod ${RDEPEND} )"

SRC_TEST=do
mydoc="NEWS"

src_install() {
	perl-module_src_install
	dodir /etc/clive
	cat <<-EOF > "${ED}"/etc/clive/config || die
	--quvi "quvi %u"
	--get-with "if type -P wget >/dev/null 2>&1; then wget -c -O %f %u; else curl -L -C - -o %f %u; fi"
	--filename-format "%t.%s"
	EOF
}

src_test() {
	if [ -z "${I_WANT_CLIVE_HOSTS_TESTS}" ] ; then
		elog "If you wish to run the full testsuite of ${PN}"
		elog "Please set the variable 'I_WANT_CLIVE_HOSTS_TESTS' variable"
		elog "Note that the tests try to download some videos from various websites"
		elog "and thus may randomly fail depending on the site's status."
		export NO_INTERNET=1
	fi
	perl-module_src_test
}
