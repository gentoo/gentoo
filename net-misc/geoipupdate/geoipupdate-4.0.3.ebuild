# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_PN="github.com/maxmind/geoipupdate"
EGO_VENDOR=(
	"${EGO_PN} v${PV}"
	"github.com/pkg/errors v0.8.1"
	"github.com/spf13/pflag v1.0.3"
	"github.com/gofrs/flock v0.7.1"
)

inherit golang-build golang-vcs-snapshot

DESCRIPTION="Performs automatic updates of GeoIP2 binary databases"
HOMEPAGE="https://github.com/maxmind/geoipupdate"
SRC_URI="${EGO_VENDOR_URI}"

LICENSE="|| ( Apache-2.0 MIT )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc64 ~s390 ~sparc ~x86 ~x86-fbsd"

src_compile() {
	pushd "src/${EGO_PN}" > /dev/null || die
	local TEST="-ldflags '-X main.version=${PV}'"
	set -- env GOPATH="${S}" go build -v -work -x -ldflags \
		"-X main.version=${PV} -X main.defaultConfigFile=/etc/GeoIP.conf -X main.defaultDatabaseDirectory=/usr/share/GeoIP" \
		./...
	echo "$@"
	"$@" || die "compile failed"
	popd > /dev/null
}

src_install() {
	pushd "src/${EGO_PN}" > /dev/null || die
	set -- env GOPATH="${S}" go install -v -work -x -ldflags \
		"-X main.version=${PV} -X main.defaultConfigFile=/etc/GeoIP.conf -X main.defaultDatabaseDirectory=/usr/share/GeoIP" \
		./...
	echo "$@"
	"$@" || die
	dobin "${S}/bin/geoipupdate"
	insinto /etc
	newins "${S}/src/${EGO_PN}/conf/GeoIP.conf.default" GeoIP.conf
	dodoc "${S}/src/${EGO_PN}/doc/"{GeoIP.conf,geoipupdate}.md "${S}/src/${EGO_PN}/README.md"
	keepdir /usr/share/GeoIP
}

pkg_postinst() {
	elog "Please read https://dev.maxmind.com/geoip/geoipupdate/upgrading-to-geoip-update-4-x/ for upgrade notes."
}
