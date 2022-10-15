# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
MY_PN=kcat

inherit toolchain-funcs

DESCRIPTION="Generic command line non-JVM Apache Kafka producer and consumer"
HOMEPAGE="https://github.com/edenhill/kcat"
SRC_URI="https://github.com/edenhill/kcat/archive/${PV}.tar.gz -> ${MY_PN}-${PV}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+avro +json"

DEPEND=">=dev-libs/librdkafka-0.9.4
	avro? (
		dev-libs/avro-c
		dev-libs/libserdes
	)
	json? ( dev-libs/yajl )"
RDEPEND="${DEPEND}"

# tests require a running kafka cluster
RESTRICT="test"

S="${WORKDIR}/${MY_PN}-${PV}"

src_configure() {
	econf $(use_enable avro) $(use_enable json) --cc="$(tc-getCC)"
}

src_install() {
	default
	dodoc CHANGELOG.md
	doman ${MY_PN}.1
}

pkg_postinst() {
	ewarn "Note that starting with version 1.7.1 the executable name"
	ewarn "was changed from kafkacat to kcat"
}
