# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SHEVEK
DIST_VERSION=0.31
inherit perl-module

DESCRIPTION="Interface to Sender Rewriting Scheme"

SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	>=dev-perl/Digest-HMAC-1.10.0-r1
	>=dev-perl/MLDBM-2.10.0
	>=virtual/perl-DB_File-1.807.0
	>=virtual/perl-Digest-MD5-2.330.0
	>=virtual/perl-Storable-2.40.0-r1"
BDEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Simple )
"

PERL_RM_FILES=( t/10_pod.t t/11_pod_coverage.t )

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
