# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ALINKE
DIST_VERSION=0.29
inherit perl-module

DESCRIPTION="Transliterates text between writing systems"

SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~riscv ~x86"

BDEPEND="virtual/perl-ExtUtils-MakeMaker"
