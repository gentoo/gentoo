# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Avro SerializationDeserialization w/ Confluent schema-registry support"
HOMEPAGE="https://github.com/confluentinc/libserdes"
SRC_URI="https://github.com/confluentinc/libserdes/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-libs/jansson:=
	net-misc/curl
	dev-libs/avro-c"
RDEPEND="${DEPEND}"

src_install() {
	default
	# NIH reinvention of autoconf does not support autotools options
	# such as controlling shared/static libs
	rm "${ED}"/usr/$(get_libdir)/libserdes.a || die
}
