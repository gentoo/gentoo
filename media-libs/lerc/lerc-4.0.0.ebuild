# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal cmake

DESCRIPTION="Limited Error Raster Compression"
HOMEPAGE="https://github.com/esri/lerc"
SRC_URI="https://github.com/Esri/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/4"
KEYWORDS="~amd64"
