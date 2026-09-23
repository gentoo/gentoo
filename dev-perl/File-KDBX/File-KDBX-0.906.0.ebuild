# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=CCM
DIST_VERSION=0.906
inherit perl-module

DESCRIPTION="Encrypted database to store secret text and files"

SLOT="0"
KEYWORDS="~amd64 ~x86"

# File::KeePass::KDBX
RDEPEND="
	dev-perl/Crypt-Argon2
	dev-perl/CryptX
	dev-perl/Devel-GlobalDestruction
	dev-perl/File-KeePass
	dev-perl/Iterator-Simple
	dev-perl/Ref-Util
	dev-perl/Scope-Guard
	dev-perl/XML-LibXML
	dev-perl/boolean
	dev-perl/namespace-clean
"
BDEPEND="
	test? (
		${RDEPEND}
		dev-perl/File-KeePass-KDBX
	)
"
