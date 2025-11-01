# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=EHUELS
DIST_VERSION=2.1900
inherit perl-module

DESCRIPTION="Perl SASL interface"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="kerberos"

RDEPEND="
	dev-perl/Crypt-URandom
	dev-perl/Digest-HMAC
	kerberos? ( dev-perl/GSSAPI )
"
BDEPEND="
	${RDEPEND}
"
