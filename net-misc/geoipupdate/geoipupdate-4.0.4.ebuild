# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_PN="github.com/maxmind/${PN}"

inherit golang-vcs-snapshot

DESCRIPTION="performs automatic updates of GeoIP2 and GeoIP Legacy binary databases"
HOMEPAGE="https://github.com/maxmind/geoipupdate"
SRC_URI="
	https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="|| ( Apache-2.0 MIT )"
SLOT="0"
KEYWORDS="~amd64"

DOCS=( GeoIP.conf.md geoipupdate.md )

src_unpack() {
	golang-vcs-snapshot_src_unpack
}

src_compile() {
	cd src/${EGO_PN} || die
	# requires pandoc but the information is still in the distributed md files
	sed -i -e '/GeoIP.conf.5 /d' -e '/geoipupdate.1$/d' Makefile || die
	sed -i -e 's/go build/go build -x/' Makefile || die

	# the horror, the horror ... but it's all automagic
	export GO111MODULE=on
	export GOFLAGS=-mod=vendor
	export CONFFILE=/etc/GeoIP.conf
	export DATADIR=/usr/share/GeoIP
	export VERSION=${PV}
	default
}

src_install() {
	mkdir "${D}/usr/bin" -p
	cd "src/${EGO_PN}/build" || die
	cp geoipupdate "${D}/usr/bin" || die
	keepdir /usr/share/GeoIP
	insinto /etc
	doins GeoIP.conf
}
