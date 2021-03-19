# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xorg-3

DESCRIPTION="null input driver"

KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="x11-base/xorg-server"
DEPEND="${RDEPEND}"
