# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
EGO_PN="github.com/cloudnativelabs/${PN}"

inherit golang-build golang-vcs-snapshot

KEYWORDS="~amd64"

DESCRIPTION="A turnkey solution for Kubernetes networking"
HOMEPAGE="https://kube-router.io"
SRC_URI="https://github.com/cloudnativelabs/kube-router/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 MIT BSD BSD-2 MPL-2.0 ISC LGPL-3-with-linking-exception"

# It will fail (timeout) at least with standard set of FEATURES attempting to serve bgp
RESTRICT="test"

SLOT="0"

RDEPEND="
	net-firewall/iptables[conntrack]
	net-firewall/ipset
	sys-cluster/ipvsadm
"

# Vendored dependencies (helps with LICENSE, see https://bugs.gentoo.org/694792):
# github.com/aws/aws-sdk-go # Apache-2.0
# github.com/containernetworking/cni # Apache-2.0
# github.com/coreos/go-iptables # Apache-2.0
# github.com/docker/docker # Apache-2.0
# github.com/docker/distribution # Apache-2.0
# github.com/docker/go-connections # Apache-2.0
# github.com/docker/go-units # Apache-2.0
# github.com/docker/libnetwork # Apache-2.0
# github.com/osrg/gobgp # Apache-2.0
# github.com/prometheus/client_model # Apache-2.0
# github.com/prometheus/client_golang # Apache-2.0
# github.com/prometheus/common # Apache-2.0
# github.com/prometheus/procfs # Apache-2.0
# github.com/satori/go.uuid # MIT
# github.com/vishvananda/netlink # Apache-2.0
# github.com/vishvananda/netns # Apache-2.0
# github.com/beorn7/perks # MIT
# github.com/davecgh/go-spew # ISC
# github.com/dgryski/go-farm # MIT
# github.com/eapache/channels # MIT
# github.com/eapache/queue # MIT
# github.com/emicklei/go-restful # MIT
# github.com/emicklei/go-restful-swagger12 # MIT
# github.com/ghodss/yaml # MIT BSD
# github.com/go-ini/ini # Apache-2.0
# github.com/armon/go-radix # MIT
# github.com/go-openapi/spec # Apache-2.0
# github.com/gogo/protobuf # BSD
# github.com/gregjones/httpcache # MIT
# github.com/hashicorp/golang-lru # MPL-2.0
# github.com/go-openapi/jsonpointer # Apache-2.0
# github.com/go-openapi/jsonreference # Apache-2.0
# github.com/go-openapi/swag # Apache-2.0
# github.com/howeyc/gopass # ISC
# github.com/imdario/mergo # BSD
# github.com/influxdata/influxdb # MIT
# github.com/jmespath/go-jmespath # Apache-2.0
# github.com/json-iterator/go # MIT
# github.com/juju/ratelimit # LGPL-3-with-linking-exception
# github.com/opencontainers/go-digest # Apache-2.0
# github.com/opencontainers/image-spec # Apache-2.0
# github.com/peterbourgon/diskv # MIT
# github.com/PuerkitoBio/purell # BSD
# github.com/PuerkitoBio/urlesc # BSD
# github.com/mailru/easyjson # MIT
# github.com/modern-go/concurrent # Apache-2.0
# github.com/modern-go/reflect2 # Apache-2.0
# github.com/spf13/afero # Apache-2.0
# github.com/spf13/cast # MIT
# github.com/spf13/pflag # BSD
# github.com/spf13/viper # MIT
# github.com/spf13/jwalterweatherman # MIT
# github.com/fsnotify/fsnotify # BSD
# github.com/hashicorp/hcl # MPL-2.0
# github.com/magiconair/properties # BSD-2
# github.com/mitchellh/mapstructure # MIT
# github.com/pelletier/go-toml # MIT
# github.com/sirupsen/logrus # MIT
# github.com/matttproud/golang_protobuf_extensions # Apache-2.0
# github.com/golang/protobuf # BSD
# github.com/golang/glog # Apache-2.0
# github.com/pkg/errors # BSD-2
# github.com/google/gofuzz # Apache-2.0
# github.com/google/btree # Apache-2.0
# github.com/googleapis/gnostic # Apache-2.0
# google.golang.org/grpc # Apache-2.0
# google.golang.org/genproto # Apache-2.0
# golang.org/x/crypto # BSD
# golang.org/x/net # BSD
# golang.org/x/sys # BSD
# golang.org/x/text # BSD
# k8s.io/api # Apache-2.0
# k8s.io/apimachinery # Apache-2.0
# k8s.io/client-go # Apache-2.0
# k8s.io/kube-openapi # Apache-2.0
# gopkg.in/inf.v0 # BSD
# gopkg.in/tomb.v2 # BSD
# gopkg.in/yaml.v2 # Apache-2.0 && MIT

# Test dependencies:
# github.com/onsi/ginkgo # MIT
# github.com/onsi/gomega # MIT

src_prepare() {
	eapply_user
	# we are going to remove some stuff that is not required for compoilation
	# but may have some license issues
	local unneeded_dir
	local unneeded_dirs=(
		github.com/howeyc/gopass/terminal_solaris.go
		github.com/docker/libnetwork/client/mflag
		github.com/prometheus/client_model/ruby
		github.com/docker/docker/contrib

		github.com/Microsoft/go-winio
		github.com/inconshreveable/mousetrap

		github.com/petar/GoLLRB
		github.com/spf13/cobra
	)
	for unneeded_dir in ${unneeded_dirs[@]}; do
		mv -v "${S}/src/${EGO_PN}/vendor/${unneeded_dir}" "${T}" || \
			die "can't remove ${unneeded_dir}"
	done
}

src_compile() {
	pushd "src/${EGO_PN}" || die
	GOPATH="${S}" go build -x -work -v \
		-ldflags "-X 'github.com/cloudnativelabs/kube-router/pkg/cmd.version=${PV}' "\
"-X 'github.com/cloudnativelabs/kube-router/pkg/cmd.buildDate=$(date -u +%FT%T%z)'" \
		-o kube-router cmd/kube-router/kube-router.go || die
	popd || die
}

src_test() {
	pushd "src/${EGO_PN}" || die
	emake GOPATH="${S}" BUILD_IN_DOCKER= test || die "Tests failed"
}

src_install() {
	pushd "src/${EGO_PN}" || die
	dobin "${PN}"
	einstalldocs
	popd || die

	newinitd "${FILESDIR}"/kube-router.initd kube-router
	newconfd "${FILESDIR}"/kube-router.confd kube-router

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/kube-router.logrotated kube-router
}
