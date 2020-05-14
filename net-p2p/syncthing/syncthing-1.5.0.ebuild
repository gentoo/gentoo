# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module systemd xdg-utils

EGO_SUM=(
	"github.com/AudriusButkevicius/pfilter v0.0.0-20190627213056-c55ef6137fc6"
	"github.com/AudriusButkevicius/pfilter v0.0.0-20190627213056-c55ef6137fc6/go.mod"
	"github.com/AudriusButkevicius/recli v0.0.5"
	"github.com/AudriusButkevicius/recli v0.0.5/go.mod"
	"github.com/BurntSushi/toml v0.3.1/go.mod"
	"github.com/StackExchange/wmi v0.0.0-20180116203802-5d049714c4a6"
	"github.com/StackExchange/wmi v0.0.0-20180116203802-5d049714c4a6/go.mod"
	"github.com/StackExchange/wmi v0.0.0-20190523213315-cbe66965904d"
	"github.com/StackExchange/wmi v0.0.0-20190523213315-cbe66965904d/go.mod"
	"github.com/alangpierce/go-forceexport v0.0.0-20160317203124-8f1d6941cd75"
	"github.com/alangpierce/go-forceexport v0.0.0-20160317203124-8f1d6941cd75/go.mod"
	"github.com/alecthomas/template v0.0.0-20160405071501-a0175ee3bccc/go.mod"
	"github.com/alecthomas/template v0.0.0-20190718012654-fb15b899a751"
	"github.com/alecthomas/template v0.0.0-20190718012654-fb15b899a751/go.mod"
	"github.com/alecthomas/units v0.0.0-20151022065526-2efee857e7cf/go.mod"
	"github.com/alecthomas/units v0.0.0-20190717042225-c3de453c63f4"
	"github.com/alecthomas/units v0.0.0-20190717042225-c3de453c63f4/go.mod"
	"github.com/beorn7/perks v0.0.0-20180321164747-3a771d992973"
	"github.com/beorn7/perks v0.0.0-20180321164747-3a771d992973/go.mod"
	"github.com/beorn7/perks v1.0.0"
	"github.com/beorn7/perks v1.0.0/go.mod"
	"github.com/beorn7/perks v1.0.1"
	"github.com/beorn7/perks v1.0.1/go.mod"
	"github.com/bkaradzic/go-lz4 v0.0.0-20160924222819-7224d8d8f27e"
	"github.com/bkaradzic/go-lz4 v0.0.0-20160924222819-7224d8d8f27e/go.mod"
	"github.com/calmh/murmur3 v1.1.1-0.20200226160057-74e9af8f47ac"
	"github.com/calmh/murmur3 v1.1.1-0.20200226160057-74e9af8f47ac/go.mod"
	"github.com/calmh/xdr v1.1.0"
	"github.com/calmh/xdr v1.1.0/go.mod"
	"github.com/ccding/go-stun v0.0.0-20180726100737-be486d185f3d"
	"github.com/ccding/go-stun v0.0.0-20180726100737-be486d185f3d/go.mod"
	"github.com/certifi/gocertifi v0.0.0-20190905060710-a5e0173ced67"
	"github.com/certifi/gocertifi v0.0.0-20190905060710-a5e0173ced67/go.mod"
	"github.com/cespare/xxhash/v2 v2.1.0"
	"github.com/cespare/xxhash/v2 v2.1.0/go.mod"
	"github.com/cheekybits/genny v1.0.0"
	"github.com/cheekybits/genny v1.0.0/go.mod"
	"github.com/chmduquesne/rollinghash v0.0.0-20180912150627-a60f8e7142b5"
	"github.com/chmduquesne/rollinghash v0.0.0-20180912150627-a60f8e7142b5/go.mod"
	"github.com/cpuguy83/go-md2man/v2 v2.0.0-20190314233015-f79a8a8ca69d"
	"github.com/cpuguy83/go-md2man/v2 v2.0.0-20190314233015-f79a8a8ca69d/go.mod"
	"github.com/d4l3k/messagediff v1.2.1"
	"github.com/d4l3k/messagediff v1.2.1/go.mod"
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/davecgh/go-spew v1.1.1"
	"github.com/davecgh/go-spew v1.1.1/go.mod"
	"github.com/flynn-archive/go-shlex v0.0.0-20150515145356-3f9db97f8568"
	"github.com/flynn-archive/go-shlex v0.0.0-20150515145356-3f9db97f8568/go.mod"
	"github.com/fsnotify/fsnotify v1.4.7"
	"github.com/fsnotify/fsnotify v1.4.7/go.mod"
	"github.com/getsentry/raven-go v0.2.0"
	"github.com/getsentry/raven-go v0.2.0/go.mod"
	"github.com/go-asn1-ber/asn1-ber v1.3.1"
	"github.com/go-asn1-ber/asn1-ber v1.3.1/go.mod"
	"github.com/go-kit/kit v0.8.0/go.mod"
	"github.com/go-kit/kit v0.9.0/go.mod"
	"github.com/go-ldap/ldap/v3 v3.1.7"
	"github.com/go-ldap/ldap/v3 v3.1.7/go.mod"
	"github.com/go-logfmt/logfmt v0.3.0/go.mod"
	"github.com/go-logfmt/logfmt v0.4.0/go.mod"
	"github.com/go-ole/go-ole v1.2.1"
	"github.com/go-ole/go-ole v1.2.1/go.mod"
	"github.com/go-ole/go-ole v1.2.4"
	"github.com/go-ole/go-ole v1.2.4/go.mod"
	"github.com/go-stack/stack v1.8.0/go.mod"
	"github.com/gobwas/glob v0.2.3"
	"github.com/gobwas/glob v0.2.3/go.mod"
	"github.com/gogo/protobuf v1.1.1/go.mod"
	"github.com/gogo/protobuf v1.3.1"
	"github.com/gogo/protobuf v1.3.1/go.mod"
	"github.com/golang/groupcache v0.0.0-20190702054246-869f871628b6"
	"github.com/golang/groupcache v0.0.0-20190702054246-869f871628b6/go.mod"
	"github.com/golang/mock v1.2.0"
	"github.com/golang/mock v1.2.0/go.mod"
	"github.com/golang/protobuf v1.2.0"
	"github.com/golang/protobuf v1.2.0/go.mod"
	"github.com/golang/protobuf v1.3.0/go.mod"
	"github.com/golang/protobuf v1.3.1"
	"github.com/golang/protobuf v1.3.1/go.mod"
	"github.com/golang/protobuf v1.3.2"
	"github.com/golang/protobuf v1.3.2/go.mod"
	"github.com/golang/snappy v0.0.1"
	"github.com/golang/snappy v0.0.1/go.mod"
	"github.com/google/go-cmp v0.3.0"
	"github.com/google/go-cmp v0.3.0/go.mod"
	"github.com/google/gofuzz v1.0.0/go.mod"
	"github.com/hpcloud/tail v1.0.0"
	"github.com/hpcloud/tail v1.0.0/go.mod"
	"github.com/jackpal/gateway v1.0.6"
	"github.com/jackpal/gateway v1.0.6/go.mod"
	"github.com/jackpal/go-nat-pmp v1.0.2"
	"github.com/jackpal/go-nat-pmp v1.0.2/go.mod"
	"github.com/json-iterator/go v1.1.6/go.mod"
	"github.com/json-iterator/go v1.1.7/go.mod"
	"github.com/julienschmidt/httprouter v1.2.0/go.mod"
	"github.com/kballard/go-shellquote v0.0.0-20180428030007-95032a82bc51"
	"github.com/kballard/go-shellquote v0.0.0-20180428030007-95032a82bc51/go.mod"
	"github.com/kisielk/errcheck v1.2.0/go.mod"
	"github.com/kisielk/gotool v1.0.0/go.mod"
	"github.com/konsorten/go-windows-terminal-sequences v1.0.1/go.mod"
	"github.com/kr/logfmt v0.0.0-20140226030751-b84e30acd515/go.mod"
	"github.com/kr/pretty v0.2.0"
	"github.com/kr/pretty v0.2.0/go.mod"
	"github.com/kr/pty v1.1.1/go.mod"
	"github.com/kr/text v0.1.0"
	"github.com/kr/text v0.1.0/go.mod"
	"github.com/lib/pq v1.2.0"
	"github.com/lib/pq v1.2.0/go.mod"
	"github.com/lucas-clemente/quic-go v0.14.4"
	"github.com/lucas-clemente/quic-go v0.14.4/go.mod"
	"github.com/marten-seemann/chacha20 v0.2.0"
	"github.com/marten-seemann/chacha20 v0.2.0/go.mod"
	"github.com/marten-seemann/qpack v0.1.0/go.mod"
	"github.com/marten-seemann/qtls v0.4.1"
	"github.com/marten-seemann/qtls v0.4.1/go.mod"
	"github.com/maruel/panicparse v1.3.0"
	"github.com/maruel/panicparse v1.3.0/go.mod"
	"github.com/mattn/go-colorable v0.1.1"
	"github.com/mattn/go-colorable v0.1.1/go.mod"
	"github.com/mattn/go-isatty v0.0.5/go.mod"
	"github.com/mattn/go-isatty v0.0.7"
	"github.com/mattn/go-isatty v0.0.7/go.mod"
	"github.com/mattn/go-isatty v0.0.11"
	"github.com/mattn/go-isatty v0.0.11/go.mod"
	"github.com/matttproud/golang_protobuf_extensions v1.0.1"
	"github.com/matttproud/golang_protobuf_extensions v1.0.1/go.mod"
	"github.com/mgutz/ansi v0.0.0-20170206155736-9520e82c474b"
	"github.com/mgutz/ansi v0.0.0-20170206155736-9520e82c474b/go.mod"
	"github.com/minio/sha256-simd v0.1.1"
	"github.com/minio/sha256-simd v0.1.1/go.mod"
	"github.com/modern-go/concurrent v0.0.0-20180228061459-e0a39a4cb421/go.mod"
	"github.com/modern-go/concurrent v0.0.0-20180306012644-bacd9c7ef1dd/go.mod"
	"github.com/modern-go/reflect2 v0.0.0-20180701023420-4b7aa43c6742/go.mod"
	"github.com/modern-go/reflect2 v1.0.1/go.mod"
	"github.com/mwitkow/go-conntrack v0.0.0-20161129095857-cc309e4a2223/go.mod"
	"github.com/onsi/ginkgo v1.6.0/go.mod"
	"github.com/onsi/ginkgo v1.7.0"
	"github.com/onsi/ginkgo v1.7.0/go.mod"
	"github.com/onsi/gomega v1.4.3"
	"github.com/onsi/gomega v1.4.3/go.mod"
	"github.com/oschwald/geoip2-golang v1.4.0"
	"github.com/oschwald/geoip2-golang v1.4.0/go.mod"
	"github.com/oschwald/maxminddb-golang v1.6.0"
	"github.com/oschwald/maxminddb-golang v1.6.0/go.mod"
	"github.com/petermattis/goid v0.0.0-20180202154549-b0b1615b78e5"
	"github.com/petermattis/goid v0.0.0-20180202154549-b0b1615b78e5/go.mod"
	"github.com/pkg/errors v0.8.0/go.mod"
	"github.com/pkg/errors v0.8.1"
	"github.com/pkg/errors v0.8.1/go.mod"
	"github.com/pkg/errors v0.9.1"
	"github.com/pkg/errors v0.9.1/go.mod"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/prometheus/client_golang v0.9.1/go.mod"
	"github.com/prometheus/client_golang v1.0.0/go.mod"
	"github.com/prometheus/client_golang v1.2.1"
	"github.com/prometheus/client_golang v1.2.1/go.mod"
	"github.com/prometheus/client_model v0.0.0-20180712105110-5c3871d89910"
	"github.com/prometheus/client_model v0.0.0-20180712105110-5c3871d89910/go.mod"
	"github.com/prometheus/client_model v0.0.0-20190129233127-fd36f4220a90"
	"github.com/prometheus/client_model v0.0.0-20190129233127-fd36f4220a90/go.mod"
	"github.com/prometheus/client_model v0.0.0-20190812154241-14fe0d1b01d4"
	"github.com/prometheus/client_model v0.0.0-20190812154241-14fe0d1b01d4/go.mod"
	"github.com/prometheus/common v0.4.1"
	"github.com/prometheus/common v0.4.1/go.mod"
	"github.com/prometheus/common v0.7.0"
	"github.com/prometheus/common v0.7.0/go.mod"
	"github.com/prometheus/procfs v0.0.0-20181005140218-185b4288413d/go.mod"
	"github.com/prometheus/procfs v0.0.2"
	"github.com/prometheus/procfs v0.0.2/go.mod"
	"github.com/prometheus/procfs v0.0.5"
	"github.com/prometheus/procfs v0.0.5/go.mod"
	"github.com/rcrowley/go-metrics v0.0.0-20190826022208-cac0b30c2563"
	"github.com/rcrowley/go-metrics v0.0.0-20190826022208-cac0b30c2563/go.mod"
	"github.com/russross/blackfriday/v2 v2.0.1"
	"github.com/russross/blackfriday/v2 v2.0.1/go.mod"
	"github.com/sasha-s/go-deadlock v0.2.0"
	"github.com/sasha-s/go-deadlock v0.2.0/go.mod"
	"github.com/shirou/gopsutil v0.0.0-20190714054239-47ef3260b6bf"
	"github.com/shirou/gopsutil v0.0.0-20190714054239-47ef3260b6bf/go.mod"
	"github.com/shirou/w32 v0.0.0-20160930032740-bb4de0191aa4/go.mod"
	"github.com/shurcooL/sanitized_anchor_name v1.0.0"
	"github.com/shurcooL/sanitized_anchor_name v1.0.0/go.mod"
	"github.com/sirupsen/logrus v1.2.0/go.mod"
	"github.com/sirupsen/logrus v1.4.2"
	"github.com/sirupsen/logrus v1.4.2/go.mod"
	"github.com/stretchr/objx v0.1.0/go.mod"
	"github.com/stretchr/objx v0.1.1/go.mod"
	"github.com/stretchr/testify v1.2.2"
	"github.com/stretchr/testify v1.2.2/go.mod"
	"github.com/stretchr/testify v1.3.0"
	"github.com/stretchr/testify v1.3.0/go.mod"
	"github.com/stretchr/testify v1.4.0"
	"github.com/stretchr/testify v1.4.0/go.mod"
	"github.com/syncthing/notify v0.0.0-20190709140112-69c7a957d3e2"
	"github.com/syncthing/notify v0.0.0-20190709140112-69c7a957d3e2/go.mod"
	"github.com/syndtr/goleveldb v1.0.1-0.20190923125748-758128399b1d"
	"github.com/syndtr/goleveldb v1.0.1-0.20190923125748-758128399b1d/go.mod"
	"github.com/thejerf/suture v3.0.2+incompatible"
	"github.com/thejerf/suture v3.0.2+incompatible/go.mod"
	"github.com/twmb/murmur3 v1.1.3"
	"github.com/twmb/murmur3 v1.1.3/go.mod"
	"github.com/urfave/cli v1.20.0"
	"github.com/urfave/cli v1.20.0/go.mod"
	"github.com/urfave/cli v1.22.2"
	"github.com/urfave/cli v1.22.2/go.mod"
	"github.com/vitrun/qart v0.0.0-20160531060029-bf64b92db6b0"
	"github.com/vitrun/qart v0.0.0-20160531060029-bf64b92db6b0/go.mod"
	"github.com/willf/bitset v1.1.10"
	"github.com/willf/bitset v1.1.10/go.mod"
	"github.com/willf/bloom v2.0.3+incompatible"
	"github.com/willf/bloom v2.0.3+incompatible/go.mod"
	"golang.org/x/crypto v0.0.0-20180904163835-0709b304e793/go.mod"
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2"
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
	"golang.org/x/crypto v0.0.0-20190829043050-9756ffdc2472"
	"golang.org/x/crypto v0.0.0-20190829043050-9756ffdc2472/go.mod"
	"golang.org/x/crypto v0.0.0-20200221231518-2aa609cf4a9d"
	"golang.org/x/crypto v0.0.0-20200221231518-2aa609cf4a9d/go.mod"
	"golang.org/x/net v0.0.0-20180906233101-161cd47e91fd/go.mod"
	"golang.org/x/net v0.0.0-20181114220301-adae6a3d119a/go.mod"
	"golang.org/x/net v0.0.0-20190228165749-92fc7df08ae7/go.mod"
	"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod"
	"golang.org/x/net v0.0.0-20190613194153-d28f0bde5980/go.mod"
	"golang.org/x/net v0.0.0-20190827160401-ba9fcec4b297"
	"golang.org/x/net v0.0.0-20190827160401-ba9fcec4b297/go.mod"
	"golang.org/x/sync v0.0.0-20180314180146-1d60e4601c6f/go.mod"
	"golang.org/x/sync v0.0.0-20181108010431-42b317875d0f"
	"golang.org/x/sync v0.0.0-20181108010431-42b317875d0f/go.mod"
	"golang.org/x/sync v0.0.0-20181221193216-37e7f081c4d4/go.mod"
	"golang.org/x/sys v0.0.0-20180905080454-ebe1bf3edb33/go.mod"
	"golang.org/x/sys v0.0.0-20180909124046-d0be0721c37e/go.mod"
	"golang.org/x/sys v0.0.0-20180926160741-c2ed4eda69e7/go.mod"
	"golang.org/x/sys v0.0.0-20181116152217-5ac8a444bdc5/go.mod"
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a"
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
	"golang.org/x/sys v0.0.0-20190222072716-a9d3bda3a223"
	"golang.org/x/sys v0.0.0-20190222072716-a9d3bda3a223/go.mod"
	"golang.org/x/sys v0.0.0-20190412213103-97732733099d/go.mod"
	"golang.org/x/sys v0.0.0-20190422165155-953cdadca894/go.mod"
	"golang.org/x/sys v0.0.0-20190904154756-749cb33beabd/go.mod"
	"golang.org/x/sys v0.0.0-20191010194322-b09406accb47"
	"golang.org/x/sys v0.0.0-20191010194322-b09406accb47/go.mod"
	"golang.org/x/sys v0.0.0-20191026070338-33540a1f6037"
	"golang.org/x/sys v0.0.0-20191026070338-33540a1f6037/go.mod"
	"golang.org/x/sys v0.0.0-20191224085550-c709ea063b76"
	"golang.org/x/sys v0.0.0-20191224085550-c709ea063b76/go.mod"
	"golang.org/x/text v0.3.0"
	"golang.org/x/text v0.3.0/go.mod"
	"golang.org/x/text v0.3.2"
	"golang.org/x/text v0.3.2/go.mod"
	"golang.org/x/time v0.0.0-20190308202827-9d24e82272b4"
	"golang.org/x/time v0.0.0-20190308202827-9d24e82272b4/go.mod"
	"golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod"
	"golang.org/x/tools v0.0.0-20181030221726-6c7e314b6563/go.mod"
	"google.golang.org/genproto v0.0.0-20180831171423-11092d34479b/go.mod"
	"gopkg.in/alecthomas/kingpin.v2 v2.2.6"
	"gopkg.in/alecthomas/kingpin.v2 v2.2.6/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/check.v1 v1.0.0-20180628173108-788fd7840127"
	"gopkg.in/check.v1 v1.0.0-20180628173108-788fd7840127/go.mod"
	"gopkg.in/fsnotify.v1 v1.4.7"
	"gopkg.in/fsnotify.v1 v1.4.7/go.mod"
	"gopkg.in/tomb.v1 v1.0.0-20141024135613-dd632973f1e7"
	"gopkg.in/tomb.v1 v1.0.0-20141024135613-dd632973f1e7/go.mod"
	"gopkg.in/yaml.v2 v2.2.1"
	"gopkg.in/yaml.v2 v2.2.1/go.mod"
	"gopkg.in/yaml.v2 v2.2.2"
	"gopkg.in/yaml.v2 v2.2.2/go.mod"
)

go-module_set_globals

DESCRIPTION="Open Source Continuous File Synchronization"
HOMEPAGE="https://syncthing.net"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

LICENSE="Apache-2.0 BSD BSD-2 ISC MIT MPL-2.0 Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="selinux tools"

RDEPEND="acct-group/syncthing
	acct-user/syncthing
	tools? ( acct-group/stdiscosrv
		acct-group/strelaysrv
		acct-user/stdiscosrv
		acct-user/strelaysrv )
	selinux? ( sec-policy/selinux-syncthing )"

DOCS=( README.md AUTHORS CONTRIBUTING.md )

PATCHES=(
	"${FILESDIR}"/${PN}-1.3.4-TestIssue5063_timeout.patch
)

src_prepare() {
	# Bug #679280
	xdg_environment_reset

	default
	sed -i \
		's|^ExecStart=.*|ExecStart=/usr/libexec/syncthing/strelaysrv|' \
		cmd/strelaysrv/etc/linux-systemd/strelaysrv.service \
		|| die

	# As of 1.4.2, stupgrades still fails to compile. This command was not present
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
