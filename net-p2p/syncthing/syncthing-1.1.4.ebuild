# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_PN="github.com/${PN}/${PN}"

EGO_VENDOR=(
	"github.com/AudriusButkevicius/go-nat-pmp 452c97607362b2ab5a7839b8d1704f0396b640ca"
	"github.com/AudriusButkevicius/recli v0.0.5"
	"github.com/bkaradzic/go-lz4 7224d8d8f27ef618c0a95f1ae69dbb0488abc33a"
	"github.com/calmh/du v1.0.1"
	"github.com/calmh/xdr v1.1.0"
	"github.com/chmduquesne/rollinghash a60f8e7142b536ea61bb5d84014171189eeaaa81"
	"github.com/d4l3k/messagediff v1.2.1"
	"github.com/davecgh/go-spew v1.1.1"
	"github.com/flynn-archive/go-shlex 3f9db97f856818214da2e1057f8ad84803971cff"
	"github.com/gobwas/glob 51eb1ee00b6d931c66d229ceeb7c31b985563420"
	"github.com/gogo/protobuf v1.2.1"
	"github.com/golang/groupcache 84a468cf14b4376def5d68c722b139b881c450a4"
	"github.com/golang/snappy 553a641470496b2327abcac10b36396bd98e45c9"
	"github.com/jackpal/gateway 5795ac81146e01d3fab7bcf21c043c3d6a32b006"
	"github.com/kballard/go-shellquote cd60e84ee657ff3dc51de0b4f55dd299a3e136f2"
	"github.com/kr/pretty v0.1.0"
	"github.com/lib/pq v1.1.1"
	"github.com/mattn/go-isatty v0.0.7"
	"github.com/minio/sha256-simd cc1980cb03383b1d46f518232672584432d7532d"
	"github.com/onsi/ginkgo 6c46eb8334b30dc55b42f1a1c725d5ce97375390"
	"github.com/onsi/gomega ba3724c94e4dd5d5690d37c190f1c54b2c1b4e64"
	"github.com/oschwald/geoip2-golang v1.3.0"
	"github.com/oschwald/maxminddb-golang 26fe5ace1c706491c2936119e1dc69c1a9c04d7f"
	"github.com/petermattis/goid 3db12ebb2a599ba4a96bea1c17b61c2f78a40e02"
	"github.com/pkg/errors v0.8.1"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/prometheus/client_golang v0.9.2"
	"github.com/rcrowley/go-metrics e181e095bae94582363434144c61a9653aff6e50"
	"github.com/sasha-s/go-deadlock v0.2.0"
	"github.com/stretchr/testify v1.2.2"
	"github.com/syncthing/notify 4e389ea6c0d84e6195eb585ffaf62c8c143306ae"
	"github.com/syndtr/goleveldb 34011bf325bce385408353a30b101fe5e923eb6e"
	"github.com/thejerf/suture v3.0.2"
	"github.com/urfave/cli v1.20.0"
	"github.com/vitrun/qart bf64b92db6b05651d6c25a3dabf2d543b360c0aa"
	"golang.org/x/crypto 0fcca4842a8d74bfddc2c96a073bd2a4d2a7a2e8 github.com/golang/crypto"
	"golang.org/x/net 351d144fa1fc0bd934e2408202be0c29f25e35a0 github.com/golang/net"
	"golang.org/x/sys 4d1cda033e0619309c606fc686de3adcf599539e github.com/golang/sys"
	"golang.org/x/text e19ae1496984b1c655b8044a65c0300a3c878dd3 github.com/golang/text"
	"golang.org/x/time 6dc17368e09b0e8634d71cac8168d853e869a0c7 github.com/golang/time"
	"gopkg.in/asn1-ber.v1 v1.2 github.com/go-asn1-ber/asn1-ber"
	"gopkg.in/check.v1 788fd78401277ebd861206a03c884797c6ec5541 github.com/go-check/check"
	"gopkg.in/ldap.v2 v2.5.1 github.com/go-ldap/ldap"
	"gopkg.in/yaml.v2 v2.0.0 github.com/go-yaml/yaml"
	# These are only used by the test suite but conditional vendoring is messy
	"github.com/beorn7/perks 3a771d992973f24aa725d07868b467d1ddfceafb"
	"github.com/golang/protobuf v1.2.0"
	"github.com/matttproud/golang_protobuf_extensions v1.0.1"
	"github.com/prometheus/client_model 5c3871d89910bfb32f5fcab2aa4b9ec68e65a99f"
	"github.com/prometheus/common v0.1.0"
	"github.com/prometheus/procfs 1dc9a6cbc91aacc3e8b2d63db4d2e957a5394ac4"
)

inherit golang-vcs-snapshot systemd user xdg-utils

DESCRIPTION="Open Source Continuous File Synchronization"
HOMEPAGE="https://syncthing.net"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="Apache-2.0 BSD BSD-2 ISC MIT MPL-2.0 Unlicense"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="selinux tools"

BDEPEND="<dev-lang/go-1.13"
RDEPEND="selinux? ( sec-policy/selinux-syncthing )"

DOCS=( README.md AUTHORS CONTRIBUTING.md )

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/${PN} ${PN}

	if use tools ; then
		# separate user for the discovery server
		enewgroup stdiscosrv
		enewuser stdiscosrv -1 -1 /var/lib/stdiscosrv stdiscosrv
		keepdir /var/lib/stdiscosrv
		fowners stdiscosrv:stdiscosrv /var/lib/stdiscosrv

		# separate user for the relay server
		enewgroup strelaysrv
		enewuser strelaysrv -1 -1 /var/lib/strelaysrv strelaysrv
		# and his home folder
		keepdir /var/lib/strelaysrv
		fowners strelaysrv:strelaysrv /var/lib/strelaysrv
	fi
}

src_prepare() {
	# Bug #679280
	xdg_environment_reset

	default
	sed -i \
		's|^ExecStart=.*|ExecStart=/usr/libexec/syncthing/strelaysrv|' \
		src/${EGO_PN}/cmd/strelaysrv/etc/linux-systemd/strelaysrv.service \
		|| die
}

src_compile() {
	export GOPATH="${S}:$(get_golibdir_gopath)"
	cd src/${EGO_PN} || die
	go run build.go -version "v${PV}" -no-upgrade install \
		$(usex tools "all" "") || die "build failed"
}

src_test() {
	cd src/${EGO_PN} || die
	go run build.go test || die "test failed"
}

src_install() {
	pushd src/${EGO_PN} >& /dev/null || die
	doman man/*.[157]
	einstalldocs

	dobin bin/syncthing
	if use tools ; then
		exeinto /usr/libexec/syncthing
		local exe
		for exe in bin/* ; do
			[[ "${exe}" == "bin/syncthing" ]] || doexe "${exe}"
		done
	fi
	popd >& /dev/null || die

	# openrc and systemd service files
	systemd_dounit src/${EGO_PN}/etc/linux-systemd/system/${PN}{@,-resume}.service
	systemd_douserunit src/${EGO_PN}/etc/linux-systemd/user/${PN}.service
	newconfd "${FILESDIR}/${PN}.confd" ${PN}
	newinitd "${FILESDIR}/${PN}.initd" ${PN}

	keepdir /var/{lib,log}/${PN}
	fowners ${PN}:${PN} /var/{lib,log}/${PN}
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotate" ${PN}

	if use tools ; then
		# openrc and systemd service files

		systemd_dounit "${FILESDIR}/stdiscosrv.service"
		newconfd "${FILESDIR}/stdiscosrv.confd" stdiscosrv
		newinitd "${FILESDIR}/stdiscosrv.initd" stdiscosrv

		systemd_dounit src/${EGO_PN}/cmd/strelaysrv/etc/linux-systemd/strelaysrv.service
		newconfd "${FILESDIR}/strelaysrv.confd" strelaysrv
		newinitd "${FILESDIR}/strelaysrv.initd" strelaysrv

		insinto /etc/logrotate.d
		newins "${FILESDIR}/stdiscosrv.logrotate" strelaysrv
		newins "${FILESDIR}/strelaysrv.logrotate" strelaysrv
	fi
}
