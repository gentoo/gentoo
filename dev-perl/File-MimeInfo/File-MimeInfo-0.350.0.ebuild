# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MICHIELB
DIST_VERSION=0.35
inherit perl-module

DESCRIPTION="Determine file type"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	dev-perl/Encode-Locale
	>=dev-perl/File-BaseDir-0.30.0
	>=dev-perl/File-DesktopEntry-0.40.0
	x11-misc/shared-mime-info
"
BDEPEND="${RDEPEND}"

PERL_RM_FILES=(
	t/06_pod_ok.t
	t/07_pod_cover.t
	t/08_changes.t
	t/09_no404s.t
)
