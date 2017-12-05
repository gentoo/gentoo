# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit xorg-2

DESCRIPTION="SiS USB video driver"
KEYWORDS="alpha amd64 arm ~arm64 ia64 ppc ppc64 ~sh sparc x86"
IUSE=""

RDEPEND=">=x11-base/xorg-server-1.6"
DEPEND="${RDEPEND}"
