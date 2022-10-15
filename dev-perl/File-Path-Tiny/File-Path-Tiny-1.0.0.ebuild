# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="DMUEY"
DIST_VERSION="1.0"

inherit perl-module

DESCRIPTION="Recursive versions of mkdir() and rmdir() without as much overhead as File::Path"

SLOT="0"
KEYWORDS="~amd64"

BDEPEND="test? ( dev-perl/Test-Exception )"
