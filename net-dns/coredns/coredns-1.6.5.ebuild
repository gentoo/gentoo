# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_VENDOR=(
    "github.com/coredns/federation e032b096babe" # Apache-2.0
    "golang.org/x/crypto 34f69633bfdc github.com/golang/crypto" # BSD
    "golang.org/x/net d98b1b443823 github.com/golang/net" # BSD
    "golang.org/x/sys b09406accb47 github.com/golang/sys" # BSD
    "golang.org/x/text v0.3.2 github.com/golang/text" # BSD
    "golang.org/x/oauth2 0f29369cfe45 github.com/golang/oauth2" # BSD
    "golang.org/x/xerrors a985d3407aa7 github.com/golang/xerrors" # BSD
    "golang.org/x/time 9d24e82272b4 github.com/golang/time" # BSD
    "github.com/golang/protobuf v1.3.2" # BSD
    "github.com/golang/snappy 2e65f85255db" # BSD
    "github.com/Azure/azure-sdk-for-go v31.1.0" # Apache-2.0
    "github.com/Azure/go-autorest v13.0.0" # Apache-2.0
    "github.com/aws/aws-sdk-go v1.25.19" # Apache-2.0
    "github.com/caddyserver/caddy v1.0.3" # Apache-2.0
    "github.com/dgrijalva/jwt-go v3.2.0" # MIT
    "github.com/dimchansky/utfbom v1.1.0" # Apache-2.0
    "github.com/dnstap/golang-dnstap 2cf77a2b5e11" # Apache-2.0
    "github.com/farsightsec/golang-framestream 8a0cb8ba8710" # Apache-2.0
    "github.com/flynn/go-shlex 3f9db97f8568 github.com/flynn-archive/go-shlex" # Apache-2.0
    "github.com/grpc-ecosystem/grpc-opentracing 8e809c8a8645" # BSD
    "github.com/infobloxopen/go-trees 2af4e13f9062" # Apache-2.0
    "github.com/jmespath/go-jmespath c2b33e8439af" # Apache-2.0
    "github.com/matttproud/golang_protobuf_extensions v1.0.1" # Apache-2.0
    "github.com/mholt/certmagic 6a42ef9fe8c2" # Apache-2.0
    "github.com/go-acme/lego v2.5.0" # MIT
    "github.com/cenkalti/backoff v2.1.1" # MIT
    "github.com/klauspost/cpuid v1.2.0" # MIT
    "github.com/miekg/dns v1.1.22" # BSD
    "github.com/mitchellh/go-homedir v1.1.0" # MIT
    "github.com/opentracing/opentracing-go v1.1.0" # Apache-2.0
    "github.com/openzipkin-contrib/zipkin-go-opentracing v0.3.5" # Apache-2.0
    "github.com/Shopify/sarama v1.21.0" # MIT
    "github.com/DataDog/zstd v1.3.5" # BSD
    "github.com/apache/thrift v0.12.0" # Apache-2.0
    "github.com/davecgh/go-spew v1.1.1" # ISC
    "github.com/eapache/go-resiliency v1.1.0" # MIT
    "github.com/eapache/go-xerial-snappy 776d5712da21" # MIT
    "github.com/eapache/queue v1.1.0" # MIT
    "github.com/go-logfmt/logfmt v0.4.0" # MIT
    "github.com/gogo/protobuf v1.2.1" # BSD
    "github.com/opentracing-contrib/go-observer a52f23424492" # Apache-2.0
    "github.com/pierrec/lz4 v2.0.5" # BSD
    "github.com/beorn7/perks v1.0.1" # MIT
    "github.com/cespare/xxhash/v2 v2.1.0 github.com/cespare/xxhash" # MIT
    "github.com/prometheus/client_golang v1.2.1" # Apache-2.0
    "github.com/prometheus/client_model 14fe0d1b01d4" # Apache-2.0
    "github.com/prometheus/common v0.7.0" # Apache-2.0
    "github.com/prometheus/procfs v0.0.5" # Apache-2.0
    "github.com/rcrowley/go-metrics 3113b8401b8a" # BSD-2
    "go.etcd.io/etcd a14579fbfb1a github.com/etcd-io/etcd" # Apache-2.0
    "github.com/coreos/go-systemd 93d5ec2c7f76" # Apache-2.0
    "github.com/coreos/pkg 399ea9e2e55f" # Apache-2.0
    "go.uber.org/zap v1.10.0 github.com/uber-go/zap" # MIT
    "go.uber.org/atomic v1.3.2 github.com/uber-go/atomic" # MIT
    "go.uber.org/multierr v1.1.0 github.com/uber-go/multierr" # MIT
    "github.com/google/uuid v1.1.1" # BSD
    "github.com/google/gofuzz v1.0.0" # Apache-2.0
    "github.com/google/go-cmp v0.3.0" # BSD
    "google.golang.org/api v0.13.0 github.com/googleapis/google-api-go-client" # BSD MIT
    "google.golang.org/grpc v1.24.0 github.com/grpc/grpc-go" # Apache-2.0
    "google.golang.org/genproto 710ae3a149df github.com/google/go-genproto" # Apache-2.0
    "github.com/googleapis/gax-go v2.0.5" # BSD
    "github.com/googleapis/gnostic v0.2.0" # Apache-2.0
    "cloud.google.com/go v0.41.0 github.com/googleapis/google-cloud-go" # Apache-2.0
    "go.opencensus.io v0.22.0 github.com/census-instrumentation/opencensus-go" # Apache-2.0
    "github.com/hashicorp/golang-lru v0.5.1" # MPL-2.0
    "gopkg.in/DataDog/dd-trace-go.v1 v1.19.0 github.com/DataDog/dd-trace-go" # BSD Apache-2.0
    "github.com/DataDog/datadog-go v2.2.0" # MIT
    "github.com/tinylib/msgp v1.1.0" # MIT
    "github.com/philhofer/fwd v1.0.0" # MIT
    "gopkg.in/inf.v0 v0.9.1 github.com/go-inf/inf" # BSD
    "gopkg.in/square/go-jose.v2 v2.2.2 github.com/square/go-jose" # Apache-2.0
    "gopkg.in/yaml.v2 v2.2.2 github.com/go-yaml/yaml" # Apache-2.0
    "sigs.k8s.io/yaml v1.1.0 github.com/kubernetes-sigs/yaml" # MIT BSD
    "k8s.io/api 7cf5895f2711 github.com/kubernetes/api" # Apache-2.0
    "k8s.io/apimachinery 1799e75a0719 github.com/kubernetes/apimachinery" # Apache-2.0
    "k8s.io/client-go 78d2af792bab github.com/kubernetes/client-go" # Apache-2.0
    "k8s.io/klog v0.4.0 github.com/kubernetes/klog" # Apache-2.0
    "k8s.io/utils 6999998975a7 github.com/kubernetes/utils" # Apache-2.0
    "github.com/gophercloud/gophercloud fe1ba5ce12dd" # Apache-2.0
    "github.com/imdario/mergo v0.3.7" # BSD
    "github.com/json-iterator/go v1.1.7" # MIT
    "github.com/modern-go/concurrent bacd9c7ef1dd" # Apache-2.0
    "github.com/modern-go/reflect2 v1.0.1" # Apache-2.0
    "github.com/spf13/pflag v1.0.3" # BSD
)

EGO_PN="github.com/${PN}/${PN}"

inherit go-module

EGIT_COMMIT="c2fd1b2467249d8b1bb6bbee72ad83b63dd9087f"
ARCHIVE_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="A DNS server that chains middleware"
HOMEPAGE="https://github.com/coredns/coredns"

SRC_URI="${ARCHIVE_URI}
	$(go-module_vendor_uris)"
LICENSE="Apache-2.0 MIT BSD ISC MPL-2.0 BSD-2"
SLOT="0"
IUSE=""

RESTRICT="test"

src_compile() {
	go build -v -ldflags="-X github.com/coredns/coredns/coremain.GitCommit=${EGIT_COMMIT}" || die
}

src_install() {
	dobin ${PN}
	dodoc README.md
	doman man/*

	newinitd "${FILESDIR}"/coredns.initd coredns
	newconfd "${FILESDIR}"/coredns.confd coredns

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/coredns.logrotated coredns
}
