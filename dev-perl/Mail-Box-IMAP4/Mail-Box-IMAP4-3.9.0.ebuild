# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MARKOV
DIST_VERSION=3.009
inherit perl-module

DESCRIPTION="Mail::Box connector via IMAP4"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

RDEPEND="
	dev-perl/TimeDate
	dev-perl/Digest-HMAC
	>=virtual/perl-File-Temp-0.190.0
	>=dev-perl/Mail-Box-3
	>=dev-perl/Mail-IMAPClient-3.420.0
	>=dev-perl/Mail-Message-3.13.0
	>=dev-perl/Mail-Transport-3
	!!<dev-perl/Mail-Box-3
"
