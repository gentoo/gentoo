# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

XORG_MODULE=doc/

inherit xorg-3

DESCRIPTION="SGML entities and XML/CSS stylesheets used in X.Org docs"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

DEPEND="x11-misc/util-macros"
# RDEPEND=""
