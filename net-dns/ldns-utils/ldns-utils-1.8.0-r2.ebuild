# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P=${P/-utils}

DESCRIPTION="Set of utilities to simplify various dns(sec) tasks"
HOMEPAGE="http://www.nlnetlabs.nl/projects/ldns/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 sparc x86"
IUSE="+dane ecdsa ed25519 ed448 examples gost ssl"

REQUIRED_USE="
	ecdsa? ( ssl )
	ed25519? ( ssl )
	ed448? ( ssl )
	dane? ( ssl )
	gost? ( ssl )
"

RDEPEND=">=net-libs/ldns-1.8.0-r3[dane?,ecdsa?,ed25519?,ed448?,gost?]
	examples? ( >=net-libs/ldns-1.8.0-r3[examples(-)] )"
