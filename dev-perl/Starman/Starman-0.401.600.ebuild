# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="MIYAGAWA"
DIST_VERSION="0.4016"

inherit perl-module

DESCRIPTION="Plack::Handler::Starman - Plack adapter for Starman"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-perl/Net-Server
	dev-perl/HTTP-Date
	>=dev-perl/Module-Build-Tiny-0.39.0
	dev-perl/libwww-perl
	>=dev-perl/Plack-1.4.300
	dev-perl/HTTP-Message
	dev-perl/Data-Dump
	dev-perl/HTTP-Parser-XS"

BDEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		dev-perl/Test-Requires
		>=dev-perl/Test-TCP-2.170.0
		dev-perl/libwww-perl
		)"
