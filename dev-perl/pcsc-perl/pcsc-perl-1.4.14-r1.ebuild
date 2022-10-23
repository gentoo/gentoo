# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit perl-module

DESCRIPTION="A Perl Module for PC/SC SmartCard access"
HOMEPAGE="http://ludovic.rousseau.free.fr/softwares/pcsc-perl/"
SRC_URI="http://ludovic.rousseau.free.fr/softwares/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ~hppa ~ia64 ppc ppc64 ~sparc x86"

RESTRICT="test" # actually accesses the pcsc-lite daemon

DEPEND="
	>=sys-apps/pcsc-lite-1.6.0
"
