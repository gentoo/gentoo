# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Performs automatic updates of GeoIP2 and GeoIP Legacy binary databases"
HOMEPAGE="https://github.com/maxmind/geoipupdate"
SRC_URI="https://github.com/maxmind/geoipupdate/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-deps.tar.xz"

LICENSE="BSD MIT Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc64 ~x86"

BDEPEND="dev-go/go-md2man"

DOCS=( README.md CHANGELOG.md doc/GeoIP.conf.md doc/geoipupdate.md )

PATCHES=(
	"${FILESDIR}/geoipupdate-6.0.0-use-go-md2man-instead-of-pandoc.patch"
)

src_compile() {
	# Do not let these leak from outside into the package
	unset GOBIN GOPATH GOCODE

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

	doman build/GeoIP.conf.5 build/geoipupdate.1

	einstalldocs
}
