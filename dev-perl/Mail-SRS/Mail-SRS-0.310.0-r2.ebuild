# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=SHEVEK
MODULE_VERSION=0.31
inherit perl-module

DESCRIPTION="Interface to Sender Rewriting Scheme"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/Digest-HMAC-1.01-r1
	>=dev-perl/MLDBM-2.01
	>=virtual/perl-DB_File-1.807
	>=virtual/perl-Digest-MD5-2.33
	>=virtual/perl-Storable-2.04-r1"
DEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Simple )"

SRC_TEST="do"

src_install() {
	perl-module_src_install

	newinitd "${FILESDIR}/srsd.init" srsd
	newconfd "${FILESDIR}/srsd.conf" srsd
}

pkg_postinst() {
	einfo 'NOTE: srsd default configuration is to use a secret string.'
	einfo 'You can configure this value in /etc/conf.d/srsd.'
	einfo ''
	einfo 'You cannot use both --secret and --secretfile options combined.'
	einfo 'The former will override the latter.'
	einfo ''
	einfo 'If you want to use a secret file, make sure the file'
	einfo 'is NOT empty and contains characters.'
}

src_test() {
	perl_rm_files t/10_pod.t t/11_pod_coverage.t
	perl-module_src_test
}
