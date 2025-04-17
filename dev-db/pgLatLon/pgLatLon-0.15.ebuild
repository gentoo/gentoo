# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MYP=${PN}-v${PV}

DESCRIPTION="Spatial database extension for the PostgreSQL"
HOMEPAGE="https://www.public-software-group.org/pgLatLon"
SRC_URI="https://www.public-software-group.org/pub/projects/${PN}/v${PV}/${MYP}.tar.gz"

S="${WORKDIR}"/${MYP}

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64"

DEPEND="dev-db/postgresql:="
RDEPEND="${DEPEND}"
