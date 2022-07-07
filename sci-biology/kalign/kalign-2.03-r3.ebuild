# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Global and progressive multiple sequence alignment"
HOMEPAGE="http://msa.cgb.ki.se/"
SRC_URI="mirror://debian/pool/main/k/kalign/${PN}_${PV}.orig.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=( "${FILESDIR}"/${P}-makefile.patch )
