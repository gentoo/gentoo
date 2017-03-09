# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

EGO_SRC=github.com/Shopify/${PN}
EGO_PN=${EGO_SRC}/...

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	KEYWORDS="~amd64"
	SRC_URI="https://${EGO_SRC}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	inherit golang-vcs-snapshot
fi
inherit golang-build

DESCRIPTION="Sarama is a Go library for Apache Kafka"
HOMEPAGE="https://${EGO_SRC}"
LICENSE="MIT"
SLOT="0/${PV}"
IUSE="test"
DEPEND="dev-go/go-eapache-queue
	dev-go/go-resiliency
	dev-go/go-snappy
	test? ( dev-go/go-spew )"
RDEPEND=""

src_prepare() {
	# avoid toxiproxy dependency
	rm src/${EGO_SRC}/functional*_test.go || die
}

src_install() {
	golang-build_src_install
	rm bin/http_server || die
	dobin bin/*
}
