# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=KASEI
MODULE_VERSION=0.08
inherit perl-module

DESCRIPTION="adds a moniker to every class or module"

SLOT="0"
KEYWORDS="amd64 ~ppc ppc64 x86 ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="${RDEPEND}
	test? ( dev-perl/Lingua-EN-Inflect )"

SRC_TEST="do"
