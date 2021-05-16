# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=TINITA
MODULE_VERSION=0.40
inherit perl-module

DESCRIPTION="Perl Micro Object framework"
HOMEPAGE="https://metacpan.org/pod/distribution/Mo/lib/Mo.pod"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="${RDEPEND}"

SRC_TEST="do"
