# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=NLNETLABS
DIST_VERSION=1.03
inherit perl-module

DESCRIPTION="DNSSEC extensions to Net::DNS"
LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ~ia64 ~mips ppc ppc64 s390 sparc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

RDEPEND="
	>=dev-perl/Crypt-OpenSSL-Bignum-0.50.0
	>=dev-perl/Crypt-OpenSSL-RSA-0.280.0
	>=virtual/perl-File-Spec-0.860.0
	>=virtual/perl-MIME-Base64-2.110.0
	>=dev-perl/Net-DNS-1.10.0
	>=virtual/perl-Digest-SHA-5.230.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.470.0
	)
"

optdep_installed() {
	local chr=" "
	has_version "${1}" && chr="I"
	printf '[%s] %s\n' "${chr}" "${1}";
}

optdep_notice() {
	local i
	elog "This package has several modules which may require additional dependencies"
	elog "to use. However, it is up to you to install them separately if you need this"
	elog "optional functionality:"

	elog " - Support for DSA signature algorithm via Net::DNS::SEC::DSA"
	elog "   $(optdep_installed ">=dev-perl/Crypt-OpenSSL-DSA-0.150.0")"
	elog
	elog " - Support for ECDSA signatures via Net::DNS::SEC::ECDSA"
	elog "   $(optdep_installed ">=dev-perl/Crypt-OpenSSL-EC-1.10.0")"
	elog "   $(optdep_installed ">=dev-perl/Crypt-OpenSSL-ECDSA-0.60.0")"
	elog
	elog " - Support for reading Private Keys in creation of Net::DNS::RR::RRSIG"
	elog "   objects"
	elog "   $(optdep_installed ">=dev-perl/Crypt-OpenSSL-Random-0.100.0")"
	elog
	elog " - Support for ECC-GOST signatures via Net::DNS::SEC::ECCGOST"
	elog "   $(optdep_installed ">=dev-perl/Crypt-OpenSSL-EC-1.10.0")"
	elog "   $(optdep_installed ">=dev-perl/Crypt-OpenSSL-ECDSA-0.60.0")"
	elog "   $(optdep_installed ">=dev-perl/Digest-GOST-0.60.0")"
}

src_test() {
	optdep_notice
	elog
	elog "This module will perform additional tests if these dependencies are"
	elog "pre-installed"
	perl-module_src_test
}

pkg_postinst() {
	use test || optdep_notice
}
