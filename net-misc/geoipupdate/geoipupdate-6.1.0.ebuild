# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Performs automatic updates of GeoIP2 and GeoIP Legacy binary databases"
HOMEPAGE="https://github.com/maxmind/geoipupdate"
SRC_URI="https://github.com/maxmind/geoipupdate/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-deps.tar.xz"

LICENSE="ISC BSD BSD-2 MIT Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc64 ~s390 ~x86"

DOCS=( README.md CHANGELOG.md doc/GeoIP.conf.md doc/geoipupdate.md )

src_compile() {
	# Do not let these leak from outside into the package
	unset GOBIN GOPATH GOCODE

	# requires pandoc but the information is still in the distributed md files
	sed -i -e '/GeoIP.conf.5 /d' -e '/geoipupdate.1$/d' Makefile || die
	#sed -i -e 's/go build/go build -x/' Makefile || die

	# the horror, the horror ... but it's all automagic
	export CONFFILE=/etc/GeoIP.conf
	export DATADIR=/usr/share/GeoIP
	export VERSION=${PV}

	default
}

src_install() {
	dobin build/geoipupdate

	keepdir /usr/share/GeoIP

	insinto /etc
	doins build/GeoIP.conf

	einstalldocs
}
