# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=REATMON
DIST_VERSION=2.0
inherit perl-module

DESCRIPTION="Jabber Perl library"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ppc ppc64 ~riscv ~sparc x86"
IUSE=""

RDEPEND="
	dev-perl/XML-Stream
	dev-perl/Net-XMPP
	dev-perl/Digest-SHA1
"
BDEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-2.0-no-dot-inc.patch"
	"${FILESDIR}/${PN}-2.0-hash.patch"
)
