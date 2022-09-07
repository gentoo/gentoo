# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome.org

DESCRIPTION="Database of mobile broadband service providers"
HOMEPAGE="https://wiki.gnome.org/Projects/NetworkManager/MobileBroadband"

LICENSE="CC-PD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv sparc x86"
IUSE="test"
RESTRICT="!test? ( test ) test" # bug #856436

BDEPEND="
	dev-libs/libxslt
	test? ( dev-libs/libxml2 )
"

DOCS=( README )
