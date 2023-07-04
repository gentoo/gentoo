# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=KASEI
DIST_VERSION=0.08
inherit perl-module

DESCRIPTION="Adds a moniker to every class or module"

SLOT="0"
KEYWORDS="amd64 ~ppc ppc64 x86"

RDEPEND=""
BDEPEND="${RDEPEND}
	test? ( dev-perl/Lingua-EN-Inflect )
"
