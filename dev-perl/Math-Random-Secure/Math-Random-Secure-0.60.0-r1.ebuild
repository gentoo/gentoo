# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=MKANAT
MODULE_VERSION=0.06
inherit perl-module

DESCRIPTION="Cryptographically-secure, cross-platform replacement for rand()"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="dev-perl/Any-Moose
	>=dev-perl/Crypt-Random-Source-0.70
	>=dev-perl/Math-Random-ISAAC-1.0.1
	dev-perl/Math-Random-ISAAC-XS"
DEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Warn
	)"

SRC_TEST="do"
