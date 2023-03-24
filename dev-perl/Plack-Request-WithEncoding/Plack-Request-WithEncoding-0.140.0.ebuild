# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="MOZNION"
DIST_VERSION="0.14"

inherit perl-module

DESCRIPTION="Subclass of L<Plack::Request> which supports encoded requests."

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-perl/HTTP-Message
	dev-perl/Plack
	dev-perl/Hash-MultiValue"

BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.39.0
	dev-perl/Module-Build"
