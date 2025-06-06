# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=LEEJO
DIST_VERSION=2.12
inherit perl-module

DESCRIPTION="Perl version of Dean Edward's Packer.js"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-perl/Regexp-RegGrp-1.1.1_rc
"

PERL_RM_FILES=( t/pod.t )
