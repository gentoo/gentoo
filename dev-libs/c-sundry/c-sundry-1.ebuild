# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson

DESCRIPTION="Collection of sundry convenience headers"
HOMEPAGE="https://github.com/c-util/c-sundry"
SRC_URI="https://github.com/c-util/c-sundry/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
