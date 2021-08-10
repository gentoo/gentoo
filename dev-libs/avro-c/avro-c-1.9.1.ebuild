# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake

DESCRIPTION="c library for the apache avro data serialization system"
HOMEPAGE="https://avro.apache.org/"
SRC_URI="https://archive.apache.org/dist/avro/avro-${PV}/c/avro-c-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"

DEPEND="
	app-arch/snappy
	>=dev-libs/jansson-2.3
	sys-libs/zlib"
	RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-fix-libdir.patch"
)
