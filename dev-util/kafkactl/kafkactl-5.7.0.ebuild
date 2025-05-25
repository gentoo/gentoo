# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="CLI for interacting with Kafka"
HOMEPAGE="https://github.com/deviceinsight/kafkactl"

SRC_URI="https://github.com/deviceinsight/kafkactl/archive/v${PV}.tar.gz -> ${P}.tar.gz
	http://dev.gentoo.org/~patrick/${P}-vendor.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	ego build

	touch empty.yaml
	./kafkactl docs --single-page --config-file=empty.yaml
}

src_install() {
	dobin kafkactl
	dodoc README.adoc kafkactl_docs.md
}
