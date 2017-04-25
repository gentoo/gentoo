# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Generic command line non-JVM Apache Kafka producer and consumer"
HOMEPAGE="https://github.com/edenhill/kafkacat"
SRC_URI="https://github.com/edenhill/kafkacat/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+json"

DEPEND=">=dev-libs/librdkafka-0.9.4
	json? ( dev-libs/yajl )"
RDEPEND="${DEPEND}"

src_configure() {
	econf $(use_enable json) --cc=$(tc-getCC)
}

src_install() {
	default
	doman ${PN}.1
}
