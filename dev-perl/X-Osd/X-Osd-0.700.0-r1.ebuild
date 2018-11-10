# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=GOZER
MODULE_VERSION=0.7
inherit perl-module

DESCRIPTION="Perl glue to libxosd (X OnScreen Display)"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/xosd"
RDEPEND="${DEPEND}"
