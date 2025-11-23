# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=AGRUNDMA
DIST_VERSION=1.01
inherit perl-module

DESCRIPTION="Fast C metadata and tag reader for all common audio file formats"

# License note: ambiguity: https://rt.cpan.org/Ticket/Display.html?id=132450
# Tagged GPL-2 since this seems to be the smallest common denominator
# Leaving the rest for upstream to sort out
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	test? (
		dev-perl/Test-Warn
	)
"

PERL_RM_FILES=(
	"t/02pod.t"
	"t/03podcoverage.t"
	"t/04critic.t"
)
