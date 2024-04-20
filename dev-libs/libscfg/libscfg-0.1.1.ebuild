# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="C library for a simple configuration file format"
HOMEPAGE="https://git.sr.ht/~emersion/scfg https://sr.ht/~emersion/libscfg/"
SRC_URI="
	https://git.sr.ht/~emersion/libscfg/archive/v${PV}.tar.gz
		-> ${P}.tar.gz
"
S=${WORKDIR}/${PN}-v${PV}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
