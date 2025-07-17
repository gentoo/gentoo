# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RWSTAUNER
DIST_VERSION=0.202
inherit perl-module

DESCRIPTION="Config::MVP::Slicer customized for Dist::Zilla"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/Config-MVP-Slicer
	>=dev-perl/Dist-Zilla-4.0.0
	dev-perl/Moose
"
BDEPEND="${RDEPEND}
	test? (
		>=virtual/perl-Test-Simple-0.960.0
	)
"
