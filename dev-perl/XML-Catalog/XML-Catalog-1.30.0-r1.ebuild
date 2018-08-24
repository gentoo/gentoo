# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=JFEARN
DIST_VERSION=1.03
inherit perl-module

DESCRIPTION="Resolve public identifiers and remap system identifiers"

SLOT="0"
KEYWORDS="alpha amd64 ~hppa ia64 ppc sparc x86"
IUSE=""

RDEPEND="dev-perl/XML-Parser
	>=dev-perl/libwww-perl-5.48"
DEPEND="${RDEPEND}
	dev-perl/Module-Build"
