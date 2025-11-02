# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=JETTERO
DIST_VERSION=1.6611
inherit perl-module

DESCRIPTION="A collection of very basic statistics modules"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	>=dev-perl/Number-Format-1.420.0
"
BDEPEND="${RDEPEND}"
PATCHES=(
	"${FILESDIR}/${PN}-${DIST_VERSION}-no-dot-inc.patch"
)
PERL_RM_FILES=(
	"t/pod_coverage.t"
	"t/pod.t"
	"t/critic.t"
)
