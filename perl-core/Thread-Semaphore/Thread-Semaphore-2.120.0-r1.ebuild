# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=JDHEDDEN
MODULE_VERSION=2.12
inherit perl-module

DESCRIPTION="Thread-safe semaphores"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x64-cygwin"
IUSE=""

RDEPEND="virtual/perl-threads-shared
	virtual/perl-Scalar-List-Utils"
DEPEND="${RDEPEND}"

SRC_TEST=do
