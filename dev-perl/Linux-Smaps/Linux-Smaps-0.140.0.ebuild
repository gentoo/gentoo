# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=AERUDER
DIST_VERSION=0.14
inherit perl-module linux-info

DESCRIPTION="Perl interface to /proc/PID/smaps"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"

BDEPEND="
	virtual/perl-ExtUtils-MakeMaker
"
# This is only explict due to not seeing where
# this variable gets used otherwise
pkg_setup() {
	CONFIG_CHECK="~MMU ~PROC_PAGE_MONITOR"
	linux-info_pkg_setup
}
