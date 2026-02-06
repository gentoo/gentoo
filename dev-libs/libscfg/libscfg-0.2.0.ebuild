# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="C library for a simple configuration file format"
HOMEPAGE="https://codeberg.org/emersion/libscfg"
SRC_URI="
	https://codeberg.org/emersion/libscfg/archive/v${PV}.tar.gz
		-> ${P}.tar.gz
"
S=${WORKDIR}/${PN}

LICENSE="MIT"
SLOT="0/2"
KEYWORDS="~amd64 ~arm64 ~x86"
