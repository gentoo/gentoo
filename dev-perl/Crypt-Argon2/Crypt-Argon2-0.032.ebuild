# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=LEONT
inherit perl-module

DESCRIPTION="Perl interface to the Argon2 key derivation functions"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

# TODO: unbundle app-crypt/argon2
BDEPEND="dev-perl/Dist-Build"
