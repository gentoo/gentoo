# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P=${P/-utils}

DESCRIPTION="Set of utilities to simplify various dns(sec) tasks"
HOMEPAGE="http://www.nlnetlabs.nl/projects/ldns/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 sparc x86"

RDEPEND=">=net-libs/ldns-1.8.0-r3"
