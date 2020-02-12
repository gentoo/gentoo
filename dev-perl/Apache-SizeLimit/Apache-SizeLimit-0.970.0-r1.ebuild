# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=PHRED
MODULE_VERSION=0.97
inherit perl-module

DESCRIPTION="Graceful exit for large children"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ppc ppc64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

# mod_perl < 2.0.5 bundles Apache-SizeLimit
RDEPEND="dev-perl/Linux-Pid
	!<www-apache/mod_perl-2.0.5
	>=www-apache/mod_perl-2.0.5"
DEPEND="${RDEPEND}
	test? (
		>=dev-perl/Apache-Test-1.360.0
		!www-apache/mpm_itk
	)"

SRC_TEST="do"
