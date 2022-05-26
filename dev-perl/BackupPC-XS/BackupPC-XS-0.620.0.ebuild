# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_VERSION=0.62
DIST_AUTHOR="CBARRATT"
inherit perl-module

DESCRIPTION="Perl extension for BackupPC libraries"

SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="dev-perl/Module-Build"
