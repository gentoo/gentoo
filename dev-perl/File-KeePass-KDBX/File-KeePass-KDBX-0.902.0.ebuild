# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=CCM
DIST_VERSION=0.902
inherit perl-module

DESCRIPTION="Read and write KDBX files (using the File::KDBX backend)"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/CryptX
	dev-perl/File-KDBX
	dev-perl/boolean
	dev-perl/namespace-clean
"
BDEPEND="
	test? (
		dev-perl/Test-Deep
	)
"
