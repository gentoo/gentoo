# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=JSF
inherit perl-module

DESCRIPTION="Expansion of test functionality that is frequently used while testing"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-perl/Const-Fast
	dev-perl/Importer
	dev-perl/File-chdir
	dev-perl/PadWalker
	>=dev-perl/Path-Tiny-0.144.0
	dev-perl/Scalar-Readonly
	dev-perl/Test2-Suite
	dev-perl/Test2-Tools-Explain
"
BDEPEND="${RDEPEND}"
