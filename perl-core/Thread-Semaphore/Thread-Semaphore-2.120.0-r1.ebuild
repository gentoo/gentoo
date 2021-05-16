# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=JDHEDDEN
MODULE_VERSION=2.12
inherit perl-module

DESCRIPTION="Thread-safe semaphores"

SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="virtual/perl-threads-shared
	virtual/perl-Scalar-List-Utils"
DEPEND="${RDEPEND}"

SRC_TEST=do
