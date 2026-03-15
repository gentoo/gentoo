# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TIMLEGGE
DIST_VERSION=0.52
inherit perl-module

DESCRIPTION="Provable Prime Number Generator suitable for Cryptographic Applications"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~sparc ~x86"

RDEPEND="
	dev-perl/Math-Pari
	dev-perl/Crypt-Random
"
BDEPEND="${RDEPEND}"
