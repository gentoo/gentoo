# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=URI
DIST_VERSION=1.05
inherit perl-module

DESCRIPTION="Read a file backwards by lines"

SLOT="0"

KEYWORDS="~alpha amd64 ~hppa ~ia64 ~ppc ppc64 sparc x86 ~x86-solaris"

# Race conditions between 'bw.t' and 'large_file.t'
# deleting the same file
DIST_TEST=do
