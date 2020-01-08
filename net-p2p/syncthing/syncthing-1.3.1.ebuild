# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_VENDOR=(
	"github.com/AudriusButkevicius/go-nat-pmp 452c97607362b2ab5a7839b8d1704f0396b640ca"
	"github.com/AudriusButkevicius/pfilter 0.0.5"
	"github.com/AudriusButkevicius/recli v0.0.5"
	"github.com/bkaradzic/go-lz4 7224d8d8f27ef618c0a95f1ae69dbb0488abc33a"
	"github.com/calmh/xdr v1.1.0"
	"github.com/ccding/go-stun be486d185f3d"
	"github.com/certifi/gocertifi a5e0173ced67"
	"github.com/cheekybits/genny v1.0.0"
	"github.com/chmduquesne/rollinghash a60f8e7142b536ea61bb5d84014171189eeaaa81"
	"github.com/d4l3k/messagediff v1.2.1"
	"github.com/davecgh/go-spew v1.1.1"
	"github.com/flynn-archive/go-shlex 3f9db97f856818214da2e1057f8ad84803971cff"
	"github.com/getsentry/raven-go v0.2.0"
	"github.com/gobwas/glob v0.2.3"
	"github.com/gogo/protobuf v1.3.0"
	"github.com/golang/groupcache 869f871628b6"
	"github.com/golang/snappy v0.0.1"
	"github.com/jackpal/gateway v1.0.5"
	"github.com/kballard/go-shellquote 95032a82bc51"
	"github.com/kr/pretty v0.1.0"
	"github.com/lib/pq v1.2.0"
	"github.com/lucas-clemente/quic-go v0.12.0"
	"github.com/marten-seemann/qtls v0.3.2"
	"github.com/maruel/panicparse v1.3.0"
	"github.com/mattn/go-isatty v0.0.9"
	"github.com/minio/sha256-simd v0.1.0"
	"github.com/onsi/ginkgo v1.9.0"
	"github.com/onsi/gomega v1.6.0"
	"github.com/oschwald/geoip2-golang v1.3.0"
	"github.com/oschwald/maxminddb-golang v1.4.0"
	"github.com/petermattis/goid b0b1615b78e5"
	"github.com/pkg/errors v0.8.1"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/prometheus/client_golang v1.1.0"
	"github.com/rcrowley/go-metrics cac0b30c2563"
	"github.com/shirou/gopsutil 47ef3260b6bf"
	"github.com/sasha-s/go-deadlock v0.2.0"
	"github.com/stretchr/testify v1.3.0"
	"github.com/syncthing/notify 69c7a957d3e2"
	"github.com/syndtr/goleveldb c3a204f8e965"
	"github.com/thejerf/suture v3.0.2"
	"github.com/urfave/cli v1.21.0"
	"github.com/vitrun/qart bf64b92db6b05651d6c25a3dabf2d543b360c0aa"
	"golang.org/x/crypto 9756ffdc2472 github.com/golang/crypto"
	"golang.org/x/net ba9fcec4b297 github.com/golang/net"
	"golang.org/x/sys 749cb33beabd github.com/golang/sys"
	"golang.org/x/text v0.3.2 github.com/golang/text"
	"golang.org/x/time 9d24e82272b4 github.com/golang/time"
	"gopkg.in/asn1-ber.v1 v1.2 github.com/go-asn1-ber/asn1-ber"
	"gopkg.in/check.v1 788fd78401277ebd861206a03c884797c6ec5541 github.com/go-check/check"
	"gopkg.in/ldap.v2 v2.5.1 github.com/go-ldap/ldap"
	"gopkg.in/yaml.v2 v2.2.2 github.com/go-yaml/yaml"
	# These are only used by the test suite but conditional vendoring is messy
	"github.com/beorn7/perks v1.0.1"
	"github.com/golang/protobuf v1.3.2"
	"github.com/matttproud/golang_protobuf_extensions v1.0.1"
	"github.com/prometheus/client_model 14fe0d1b01d4"
	"github.com/prometheus/common v0.6.0"
	"github.com/prometheus/procfs v0.0.4"
)

inherit go-module systemd xdg-utils

DESCRIPTION="Open Source Continuous File Synchronization"
HOMEPAGE="https://syncthing.net"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	$(go-module_vendor_uris)"

LICENSE="Apache-2.0 BSD BSD-2 ISC MIT MPL-2.0 Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="selinux tools"

# For some reason the switch to go-module.eclass has resulted in the test suite
# failing when USE=tools is set. Temporarily disable testing under such circumstances
# so that there is a a working go1.13-compatible version out there already, will
# continue to look into this.
RESTRICT="tools? ( test )"

RDEPEND="acct-group/syncthing
	acct-user/syncthing
	tools? ( acct-group/stdiscosrv
		acct-group/strelaysrv
		acct-user/stdiscosrv
		acct-user/strelaysrv )
	selinux? ( sec-policy/selinux-syncthing )"

DOCS=( README.md AUTHORS CONTRIBUTING.md )

src_prepare() {
	# Bug #679280
	xdg_environment_reset

	default
	sed -i \
		's|^ExecStart=.*|ExecStart=/usr/libexec/syncthing/strelaysrv|' \
		cmd/strelaysrv/etc/linux-systemd/strelaysrv.service \
		|| die

	# As of 1.3.1, stupgrades fails to compile. This command was not present
	# in releases older than 1.3.0, is not compiled in by default (USE=tools
	# must be set) an in any case we do not really need this, therefore just
	# get rid of the offending code until upstream has fixed it.
	rm -rf cmd/stupgrades
}

src_compile() {
	go run build.go -version "v${PV}" -no-upgrade install \
		$(usex tools "all" "") || die "build failed"
}

src_test() {
	go run build.go test || die "test failed"
}

src_install() {
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

	# openrc and systemd service files
	systemd_dounit etc/linux-systemd/system/${PN}{@,-resume}.service
	systemd_douserunit etc/linux-systemd/user/${PN}.service
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

		systemd_dounit cmd/strelaysrv/etc/linux-systemd/strelaysrv.service
		newconfd "${FILESDIR}/strelaysrv.confd" strelaysrv
		newinitd "${FILESDIR}/strelaysrv.initd" strelaysrv

		insinto /etc/logrotate.d
		newins "${FILESDIR}/stdiscosrv.logrotate" strelaysrv
		newins "${FILESDIR}/strelaysrv.logrotate" strelaysrv
	fi
}
