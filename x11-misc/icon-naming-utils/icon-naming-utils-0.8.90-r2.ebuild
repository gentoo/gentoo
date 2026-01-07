# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Utils to help with the transition to the new freedesktop.org naming scheme"
HOMEPAGE="http://tango.freedesktop.org"
SRC_URI="http://tango.freedesktop.org/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86 ~x64-solaris"

RDEPEND="
	dev-lang/perl
	dev-perl/XML-Simple"
DEPEND="${RDEPEND}"
