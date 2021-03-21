# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Don't forget to update when bumping. Used in --version output
EGIT_COMMIT="f59c03d09c3a3a12f571ad1087b979325f3dae30"

EGO_SUM=(
	"cloud.google.com/go v0.56.0" # Apache-2.0
	"github.com/Azure/azure-sdk-for-go v40.6.0+incompatible" # Apache-2.0
	"github.com/Azure/go-autorest/autorest v0.10.2" # Apache-2.0
	"github.com/Azure/go-autorest/autorest/adal v0.8.2"
	"github.com/Azure/go-autorest/autorest/azure/auth v0.4.2"
	"github.com/Azure/go-autorest/autorest/azure/cli v0.3.1"
	"github.com/Azure/go-autorest/autorest/date v0.2.0"
	"github.com/Azure/go-autorest/autorest/to v0.2.0"
	"github.com/Azure/go-autorest/logger v0.1.0"
	"github.com/Azure/go-autorest/tracing v0.5.0"
	"github.com/DataDog/datadog-go v3.5.0+incompatible" # MIT
	"github.com/DataDog/zstd v1.3.5" # BSD
	"github.com/Shopify/sarama v1.21.0" # MIT
	"github.com/apache/thrift v0.13.0" # Apache-2.0
	"github.com/aws/aws-sdk-go v1.32.1" # Apache-2.0
	"github.com/beorn7/perks v1.0.1" # MIT
	"github.com/caddyserver/caddy v1.0.5" # Apache-2.0
	"github.com/cenkalti/backoff/v4 v4.0.2" # MIT
	"github.com/cespare/xxhash/v2 v2.1.1" # MIT
	"github.com/coreos/go-systemd/v22 v22.0.0" # Apache-2.0
	"github.com/davecgh/go-spew v1.1.1" # ISC
	"github.com/dgrijalva/jwt-go v3.2.0+incompatible" # MIT
	"github.com/dimchansky/utfbom v1.1.0" # Apache-2.0
	"github.com/dnstap/golang-dnstap v0.2.0" # Apache-2.0
	"github.com/eapache/go-resiliency v1.1.0" # MIT
	"github.com/eapache/go-xerial-snappy v0.0.0-20180814174437-776d5712da21" # MIT
	"github.com/eapache/queue v1.1.0" # MIT
	"github.com/farsightsec/golang-framestream v0.0.0-20190425193708-fa4b164d59b8" # Apache-2.0
	"github.com/flynn/go-shlex v0.0.0-20150515145356-3f9db97f8568" # Apache-2.0
	"github.com/go-logfmt/logfmt v0.4.0" # MIT
	"github.com/gogo/protobuf v1.3.1" # BSD
	"github.com/golang/groupcache v0.0.0-20200121045136-8c9f03a8e57e" # Apache-2.0
	"github.com/golang/protobuf v1.4.2" # BSD
	"github.com/golang/snappy v0.0.0-20180518054509-2e65f85255db" # BSD
	"github.com/google/go-cmp v0.4.0" # BSD
	"github.com/google/gofuzz v1.1.0" # Apache-2.0
	"github.com/google/uuid v1.1.1" # BSD
	"github.com/googleapis/gax-go/v2 v2.0.5" # BSD
	"github.com/googleapis/gnostic v0.1.0" # Apache-2.0
	"github.com/gophercloud/gophercloud v0.9.0" # Apache-2.0
	"github.com/grpc-ecosystem/grpc-opentracing v0.0.0-20180507213350-8e809c8a8645" # BSD
	"github.com/hashicorp/golang-lru v0.5.4" # MPL-2.0
	"github.com/imdario/mergo v0.3.9" # BSD
	"github.com/infobloxopen/go-trees v0.0.0-20190313150506-2af4e13f9062" # Apache-2.0
	"github.com/jmespath/go-jmespath v0.3.0" # Apache-2.0
	"github.com/json-iterator/go v1.1.9" # MIT
	"github.com/matttproud/golang_protobuf_extensions v1.0.1" # Apache-2.0
	"github.com/miekg/dns v1.1.29" # BSD
	"github.com/mitchellh/go-homedir v1.1.0" # MIT
	"github.com/modern-go/concurrent v0.0.0-20180306012644-bacd9c7ef1dd" # Apache-2.0
	"github.com/modern-go/reflect2 v1.0.1" # Apache-2.0
	"github.com/opentracing-contrib/go-observer v0.0.0-20170622124052-a52f23424492" # Apache-2.0
	"github.com/opentracing/opentracing-go v1.1.0" # Apache-2.0
	"github.com/openzipkin-contrib/zipkin-go-opentracing v0.3.5" # Apache-2.0
	"github.com/philhofer/fwd v1.0.0" # MIT
	"github.com/pierrec/lz4 v2.0.5+incompatible" # BSD
	"github.com/prometheus/client_golang v1.6.0" # Apache-2.0
	"github.com/prometheus/client_model v0.2.0" # Apache-2.0
	"github.com/prometheus/common v0.10.0" # Apache-2.0
	"github.com/prometheus/procfs v0.0.11" # Apache-2.0
	"github.com/rcrowley/go-metrics v0.0.0-20181016184325-3113b8401b8a" # BSD-2
	"github.com/spf13/pflag v1.0.5" # BSD
	"github.com/tinylib/msgp v1.1.2" # MIT
	"go.etcd.io/etcd v0.5.0-alpha.5.0.20200306183522-221f0cc107cb" # Apache-2.0
	"go.opencensus.io v0.22.3" # Apache-2.0
	"go.uber.org/atomic v1.6.0" # MIT
	"go.uber.org/multierr v1.5.0" # MIT
	"go.uber.org/zap v1.14.1" # MIT
	"golang.org/x/crypto v0.0.0-20200323165209-0ec3e9974c59" # BSD
	"golang.org/x/net v0.0.0-20200324143707-d3edc9973b7e" # BSD
	"golang.org/x/oauth2 v0.0.0-20200107190931-bf48bf16ab8d" # BSD
	"golang.org/x/sync v0.0.0-20200317015054-43a5402ce75a" # BSD
	"golang.org/x/sys v0.0.0-20200420163511-1957bb5e6d1f" # BSD
	"golang.org/x/text v0.3.2" # BSD
	"golang.org/x/time v0.0.0-20191024005414-555d28b269f0" # BSD
	"golang.org/x/xerrors v0.0.0-20191204190536-9bdfabe68543" # BSD
	"google.golang.org/api v0.26.0" # BSD
	"google.golang.org/appengine v1.6.5" # Apache-2.0
	"google.golang.org/genproto v0.0.0-20200331122359-1ee6d9798940" # Apache-2.0
	"google.golang.org/grpc v1.29.1" # Apache-2.0
	"google.golang.org/protobuf v1.23.0" # BSD
	"gopkg.in/DataDog/dd-trace-go.v1 v1.24.1" # Apache-2.0 || BSD
	"gopkg.in/inf.v0 v0.9.1" # BSD
	"gopkg.in/yaml.v2 v2.2.8" # Apache-2.0
	"k8s.io/api v0.18.3" # Apache-2.0
	"k8s.io/apimachinery v0.18.3" # Apache-2.0
	"k8s.io/client-go v0.18.3" # Apache-2.0
	"k8s.io/klog v1.0.0" # Apache-2.0
	"k8s.io/utils v0.0.0-20200324210504-a9aa75ae1b89" # Apache-2.0
	"sigs.k8s.io/structured-merge-diff/v3 v3.0.0" # Apache-2.0
	"sigs.k8s.io/yaml v1.2.0" # MIT && BSD

	# Tests:
	"github.com/evanphx/json-patch v4.2.0+incompatible" # BSD
	"github.com/prometheus/prometheus v2.5.0+incompatible" # Apache-2.0
	"k8s.io/kube-openapi v0.0.0-20200410145947-61e04a5be9a6" # Apache-2.0

	# tests of tests, packaging/publishing and other stuff. not actually needed,
	# no need to copy to LICENSE.
	# But in case of problems it is easier to just uncomment to download and unpack them:
	#"github.com/Azure/go-autorest/autorest/mocks v0.3.0" # Apache-2.0
	#"github.com/BurntSushi/toml v0.3.1" # MIT
	#"github.com/Shopify/toxiproxy v2.1.4+incompatible" # MIT
	#"github.com/cockroachdb/datadriven v0.0.0-20190809214429-80d97fb3cbaa" # Apache-2.0
	#"github.com/coreos/go-semver v0.2.0" # Apache-2.0
	#"github.com/dustin/go-humanize v1.0.0" # MIT
	#"github.com/fsnotify/fsnotify v1.4.7" # BSD
	#"github.com/google/btree v1.0.0" # Apache-2.0
	#"github.com/gorilla/websocket v1.4.0" # BSD-2
	#"github.com/grpc-ecosystem/go-grpc-middleware v1.0.1-0.20190118093823-f849b5445de4" # Apache-2.0
	#"github.com/grpc-ecosystem/go-grpc-prometheus v1.2.0" # Apache-2.0
	#"github.com/grpc-ecosystem/grpc-gateway v1.9.5" # BSD
	#"github.com/hpcloud/tail v1.0.0" # MIT
	#"github.com/jonboulle/clockwork v0.1.0" # Apache-2.0
	#"github.com/konsorten/go-windows-terminal-sequences v1.0.2" # MIT
	#"github.com/kr/logfmt v0.0.0-20140226030751-b84e30acd515" # MIT
	#"github.com/kr/pretty v0.2.0" # MIT
	#"github.com/kr/text v0.1.0" # MIT
	#"github.com/onsi/ginkgo v1.11.0" # MIT
	#"github.com/onsi/gomega v1.7.0" # MIT
	#"github.com/pkg/errors v0.9.1" # BSD-2
	#"github.com/pmezard/go-difflib v1.0.0" # BSD
	#"github.com/sirupsen/logrus v1.4.2" # MIT
	#"github.com/soheilhy/cmux v0.1.4" # Apache-2.0
	#"github.com/stretchr/objx v0.1.1" # MIT
	#"github.com/stretchr/testify v1.5.1" # MIT
	#"github.com/tmc/grpc-websocket-proxy v0.0.0-20170815181823-89b8d40f7ca8" # MIT
	#"github.com/xiang90/probing v0.0.0-20190116061207-43a291ad63a2" # MIT
	#"go.etcd.io/bbolt v1.3.3" # MIT
	#"go.uber.org/tools v0.0.0-20190618225709-2cfd321de3ee" # MIT
	#"golang.org/x/lint v0.0.0-20200302205851-738671d3881b" # BSD
	#"golang.org/x/mod v0.2.0" # BSD
	#"golang.org/x/tools v0.0.0-20200331025713-a30bf2db82d4" # BSD
	#"gopkg.in/check.v1 v1.0.0-20190902080502-41f04d3bba15" # BSD-2
	#"gopkg.in/fsnotify.v1 v1.4.7" # BSD
	#"gopkg.in/tomb.v1 v1.0.0-20141024135613-dd632973f1e7" # BSD
	#"honnef.co/go/tools v0.0.1-2020.1.3" # MIT

	# mod files don't bring anything useful for reader of that ebuild
	# but they are required by go modules
	"cloud.google.com/go v0.26.0/go.mod"
	"cloud.google.com/go v0.34.0/go.mod"
	"cloud.google.com/go v0.38.0/go.mod"
	"cloud.google.com/go v0.44.1/go.mod"
	"cloud.google.com/go v0.44.2/go.mod"
	"cloud.google.com/go v0.45.1/go.mod"
	"cloud.google.com/go v0.46.3/go.mod"
	"cloud.google.com/go v0.50.0/go.mod"
	"cloud.google.com/go v0.52.0/go.mod"
	"cloud.google.com/go v0.53.0/go.mod"
	"cloud.google.com/go v0.56.0/go.mod"
	"cloud.google.com/go/bigquery v1.0.1/go.mod"
	"cloud.google.com/go/bigquery v1.3.0/go.mod"
	"cloud.google.com/go/bigquery v1.4.0/go.mod"
	"cloud.google.com/go/datastore v1.0.0/go.mod"
	"cloud.google.com/go/datastore v1.1.0/go.mod"
	"cloud.google.com/go/pubsub v1.0.1/go.mod"
	"cloud.google.com/go/pubsub v1.1.0/go.mod"
	"cloud.google.com/go/pubsub v1.2.0/go.mod"
	"cloud.google.com/go/storage v1.0.0/go.mod"
	"cloud.google.com/go/storage v1.5.0/go.mod"
	"cloud.google.com/go/storage v1.6.0/go.mod"
	"contrib.go.opencensus.io/exporter/ocagent v0.4.12/go.mod"
	"dmitri.shuralyov.com/gpu/mtl v0.0.0-20190408044501-666a987793e9/go.mod"
	"github.com/Azure/azure-sdk-for-go v32.4.0+incompatible/go.mod"
	"github.com/Azure/azure-sdk-for-go v40.6.0+incompatible/go.mod"
	"github.com/Azure/go-autorest/autorest v0.1.0/go.mod"
	"github.com/Azure/go-autorest/autorest v0.5.0/go.mod"
	"github.com/Azure/go-autorest/autorest v0.9.0/go.mod"
	"github.com/Azure/go-autorest/autorest v0.9.3/go.mod"
	"github.com/Azure/go-autorest/autorest v0.10.2/go.mod"
	"github.com/Azure/go-autorest/autorest/adal v0.1.0/go.mod"
	"github.com/Azure/go-autorest/autorest/adal v0.2.0/go.mod"
	"github.com/Azure/go-autorest/autorest/adal v0.5.0/go.mod"
	"github.com/Azure/go-autorest/autorest/adal v0.8.0/go.mod"
	"github.com/Azure/go-autorest/autorest/adal v0.8.1/go.mod"
	"github.com/Azure/go-autorest/autorest/adal v0.8.2/go.mod"
	"github.com/Azure/go-autorest/autorest/azure/auth v0.1.0/go.mod"
	"github.com/Azure/go-autorest/autorest/azure/auth v0.4.2/go.mod"
	"github.com/Azure/go-autorest/autorest/azure/cli v0.1.0/go.mod"
	"github.com/Azure/go-autorest/autorest/azure/cli v0.3.1/go.mod"
	"github.com/Azure/go-autorest/autorest/date v0.1.0/go.mod"
	"github.com/Azure/go-autorest/autorest/date v0.2.0/go.mod"
	"github.com/Azure/go-autorest/autorest/mocks v0.1.0/go.mod"
	"github.com/Azure/go-autorest/autorest/mocks v0.2.0/go.mod"
	"github.com/Azure/go-autorest/autorest/mocks v0.3.0/go.mod"
	"github.com/Azure/go-autorest/autorest/to v0.2.0/go.mod"
	"github.com/Azure/go-autorest/autorest/validation v0.1.0/go.mod"
	"github.com/Azure/go-autorest/logger v0.1.0/go.mod"
	"github.com/Azure/go-autorest/tracing v0.1.0/go.mod"
	"github.com/Azure/go-autorest/tracing v0.5.0/go.mod"
	"github.com/BurntSushi/toml v0.3.1/go.mod"
	"github.com/BurntSushi/xgb v0.0.0-20160522181843-27f122750802/go.mod"
	"github.com/DataDog/datadog-go v3.5.0+incompatible/go.mod"
	"github.com/DataDog/zstd v1.3.5/go.mod"
	"github.com/NYTimes/gziphandler v0.0.0-20170623195520-56545f4a5d46/go.mod"
	"github.com/OpenDNS/vegadns2client v0.0.0-20180418235048-a3fa4a771d87/go.mod"
	"github.com/PuerkitoBio/purell v1.0.0/go.mod"
	"github.com/PuerkitoBio/urlesc v0.0.0-20160726150825-5bd2802263f2/go.mod"
	"github.com/Shopify/sarama v1.19.0/go.mod"
	"github.com/Shopify/sarama v1.21.0/go.mod"
	"github.com/Shopify/toxiproxy v2.1.4+incompatible/go.mod"
	"github.com/akamai/AkamaiOPEN-edgegrid-golang v0.9.0/go.mod"
	"github.com/alangpierce/go-forceexport v0.0.0-20160317203124-8f1d6941cd75/go.mod"
	"github.com/alecthomas/template v0.0.0-20160405071501-a0175ee3bccc/go.mod"
	"github.com/alecthomas/template v0.0.0-20190718012654-fb15b899a751/go.mod"
	"github.com/alecthomas/units v0.0.0-20151022065526-2efee857e7cf/go.mod"
	"github.com/alecthomas/units v0.0.0-20190717042225-c3de453c63f4/go.mod"
	"github.com/aliyun/alibaba-cloud-sdk-go v0.0.0-20190808125512-07798873deee/go.mod"
	"github.com/aliyun/aliyun-oss-go-sdk v0.0.0-20190307165228-86c17b95fcd5/go.mod"
	"github.com/apache/thrift v0.12.0/go.mod"
	"github.com/apache/thrift v0.13.0/go.mod"
	"github.com/aws/aws-sdk-go v1.23.0/go.mod"
	"github.com/aws/aws-sdk-go v1.32.1/go.mod"
	"github.com/baiyubin/aliyun-sts-go-sdk v0.0.0-20180326062324-cfa1a18b161f/go.mod"
	"github.com/beorn7/perks v0.0.0-20180321164747-3a771d992973/go.mod"
	"github.com/beorn7/perks v1.0.0/go.mod"
	"github.com/beorn7/perks v1.0.1/go.mod"
	"github.com/bgentry/speakeasy v0.1.0/go.mod"
	"github.com/caddyserver/caddy v1.0.5/go.mod"
	"github.com/cenkalti/backoff/v3 v3.0.0/go.mod"
	"github.com/cenkalti/backoff/v4 v4.0.2/go.mod"
	"github.com/census-instrumentation/opencensus-proto v0.2.0/go.mod"
	"github.com/census-instrumentation/opencensus-proto v0.2.1/go.mod"
	"github.com/cespare/xxhash/v2 v2.1.1/go.mod"
	"github.com/cheekybits/genny v1.0.0/go.mod"
	"github.com/chzyer/logex v1.1.10/go.mod"
	"github.com/chzyer/readline v0.0.0-20180603132655-2972be24d48e/go.mod"
	"github.com/chzyer/test v0.0.0-20180213035817-a1ea475d72b1/go.mod"
	"github.com/client9/misspell v0.3.4/go.mod"
	"github.com/cloudflare/cloudflare-go v0.10.2/go.mod"
	"github.com/cncf/udpa/go v0.0.0-20191209042840-269d4d468f6f/go.mod"
	"github.com/cockroachdb/datadriven v0.0.0-20190809214429-80d97fb3cbaa/go.mod"
	"github.com/coreos/go-semver v0.2.0/go.mod"
	"github.com/coreos/go-systemd/v22 v22.0.0/go.mod"
	"github.com/coreos/license-bill-of-materials v0.0.0-20190913234955-13baff47494e/go.mod"
	"github.com/cpu/goacmedns v0.0.1/go.mod"
	"github.com/cpuguy83/go-md2man/v2 v2.0.0-20190314233015-f79a8a8ca69d/go.mod"
	"github.com/creack/pty v1.1.7/go.mod"
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/davecgh/go-spew v1.1.1/go.mod"
	"github.com/decker502/dnspod-go v0.2.0/go.mod"
	"github.com/dgrijalva/jwt-go v3.2.0+incompatible/go.mod"
	"github.com/dimchansky/utfbom v1.1.0/go.mod"
	"github.com/dnaeon/go-vcr v0.0.0-20180814043457-aafff18a5cc2/go.mod"
	"github.com/dnsimple/dnsimple-go v0.30.0/go.mod"
	"github.com/dnstap/golang-dnstap v0.2.0/go.mod"
	"github.com/docker/spdystream v0.0.0-20160310174837-449fdfce4d96/go.mod"
	"github.com/dustin/go-humanize v0.0.0-20171111073723-bb3d318650d4/go.mod"
	"github.com/dustin/go-humanize v1.0.0/go.mod"
	"github.com/eapache/go-resiliency v1.1.0/go.mod"
	"github.com/eapache/go-xerial-snappy v0.0.0-20180814174437-776d5712da21/go.mod"
	"github.com/eapache/queue v1.1.0/go.mod"
	"github.com/elazarl/goproxy v0.0.0-20180725130230-947c36da3153/go.mod"
	"github.com/emicklei/go-restful v0.0.0-20170410110728-ff4f55a20633/go.mod"
	"github.com/envoyproxy/go-control-plane v0.9.0/go.mod"
	"github.com/envoyproxy/go-control-plane v0.9.1-0.20191026205805-5f8ba28d4473/go.mod"
	"github.com/envoyproxy/go-control-plane v0.9.4/go.mod"
	"github.com/envoyproxy/protoc-gen-validate v0.1.0/go.mod"
	"github.com/evanphx/json-patch v4.2.0+incompatible/go.mod"
	"github.com/exoscale/egoscale v0.18.1/go.mod"
	"github.com/farsightsec/golang-framestream v0.0.0-20190425193708-fa4b164d59b8/go.mod"
	"github.com/fatih/color v1.7.0/go.mod"
	"github.com/fatih/structs v1.1.0/go.mod"
	"github.com/flynn/go-shlex v0.0.0-20150515145356-3f9db97f8568/go.mod"
	"github.com/fsnotify/fsnotify v1.4.7/go.mod"
	"github.com/ghodss/yaml v0.0.0-20150909031657-73d445a93680/go.mod"
	"github.com/ghodss/yaml v1.0.0/go.mod"
	"github.com/go-acme/lego/v3 v3.1.0/go.mod"
	"github.com/go-acme/lego/v3 v3.2.0/go.mod"
	"github.com/go-cmd/cmd v1.0.5/go.mod"
	"github.com/go-errors/errors v1.0.1/go.mod"
	"github.com/go-gl/glfw v0.0.0-20190409004039-e6da0acd62b1/go.mod"
	"github.com/go-gl/glfw/v3.3/glfw v0.0.0-20191125211704-12ad95a8df72/go.mod"
	"github.com/go-gl/glfw/v3.3/glfw v0.0.0-20200222043503-6f7a984d4dc4/go.mod"
	"github.com/go-ini/ini v1.44.0/go.mod"
	"github.com/go-kit/kit v0.8.0/go.mod"
	"github.com/go-kit/kit v0.9.0/go.mod"
	"github.com/go-logfmt/logfmt v0.3.0/go.mod"
	"github.com/go-logfmt/logfmt v0.4.0/go.mod"
	"github.com/go-logr/logr v0.1.0/go.mod"
	"github.com/go-openapi/jsonpointer v0.0.0-20160704185906-46af16f9f7b1/go.mod"
	"github.com/go-openapi/jsonreference v0.0.0-20160704190145-13c6e3589ad9/go.mod"
	"github.com/go-openapi/spec v0.0.0-20160808142527-6aced65f8501/go.mod"
	"github.com/go-openapi/swag v0.0.0-20160704191624-1d0bd113de87/go.mod"
	"github.com/go-sql-driver/mysql v1.5.0/go.mod"
	"github.com/go-stack/stack v1.8.0/go.mod"
	"github.com/godbus/dbus/v5 v5.0.3/go.mod"
	"github.com/gofrs/uuid v3.2.0+incompatible/go.mod"
	"github.com/gogo/protobuf v1.1.1/go.mod"
	"github.com/gogo/protobuf v1.2.0/go.mod"
	"github.com/gogo/protobuf v1.2.1/go.mod"
	"github.com/gogo/protobuf v1.3.1/go.mod"
	"github.com/goji/httpauth v0.0.0-20160601135302-2da839ab0f4d/go.mod"
	"github.com/golang/glog v0.0.0-20160126235308-23def4e6c14b/go.mod"
	"github.com/golang/groupcache v0.0.0-20160516000752-02826c3e7903/go.mod"
	"github.com/golang/groupcache v0.0.0-20190702054246-869f871628b6/go.mod"
	"github.com/golang/groupcache v0.0.0-20191227052852-215e87163ea7/go.mod"
	"github.com/golang/groupcache v0.0.0-20200121045136-8c9f03a8e57e/go.mod"
	"github.com/golang/mock v1.1.1/go.mod"
	"github.com/golang/mock v1.2.0/go.mod"
	"github.com/golang/mock v1.3.1/go.mod"
	"github.com/golang/mock v1.4.0/go.mod"
	"github.com/golang/mock v1.4.3/go.mod"
	"github.com/golang/protobuf v0.0.0-20161109072736-4bd1920723d7/go.mod"
	"github.com/golang/protobuf v1.2.0/go.mod"
	"github.com/golang/protobuf v1.3.0/go.mod"
	"github.com/golang/protobuf v1.3.1/go.mod"
	"github.com/golang/protobuf v1.3.2/go.mod"
	"github.com/golang/protobuf v1.3.3/go.mod"
	"github.com/golang/protobuf v1.3.5/go.mod"
	"github.com/golang/protobuf v1.4.0-rc.1/go.mod"
	"github.com/golang/protobuf v1.4.0-rc.1.0.20200221234624-67d41d38c208/go.mod"
	"github.com/golang/protobuf v1.4.0-rc.2/go.mod"
	"github.com/golang/protobuf v1.4.0-rc.4.0.20200313231945-b860323f09d0/go.mod"
	"github.com/golang/protobuf v1.4.0/go.mod"
	"github.com/golang/protobuf v1.4.2/go.mod"
	"github.com/golang/snappy v0.0.0-20180518054509-2e65f85255db/go.mod"
	"github.com/google/btree v0.0.0-20180813153112-4030bb1f1f0c/go.mod"
	"github.com/google/btree v1.0.0/go.mod"
	"github.com/google/go-cmp v0.2.0/go.mod"
	"github.com/google/go-cmp v0.3.0/go.mod"
	"github.com/google/go-cmp v0.3.1/go.mod"
	"github.com/google/go-cmp v0.4.0/go.mod"
	"github.com/google/go-querystring v1.0.0/go.mod"
	"github.com/google/gofuzz v1.0.0/go.mod"
	"github.com/google/gofuzz v1.1.0/go.mod"
	"github.com/google/martian v2.1.0+incompatible/go.mod"
	"github.com/google/pprof v0.0.0-20181206194817-3ea8567a2e57/go.mod"
	"github.com/google/pprof v0.0.0-20190515194954-54271f7e092f/go.mod"
	"github.com/google/pprof v0.0.0-20191218002539-d4f498aebedc/go.mod"
	"github.com/google/pprof v0.0.0-20200212024743-f11f1df84d12/go.mod"
	"github.com/google/pprof v0.0.0-20200229191704-1ebb73c60ed3/go.mod"
	"github.com/google/renameio v0.1.0/go.mod"
	"github.com/google/uuid v1.0.0/go.mod"
	"github.com/google/uuid v1.1.1/go.mod"
	"github.com/googleapis/gax-go/v2 v2.0.4/go.mod"
	"github.com/googleapis/gax-go/v2 v2.0.5/go.mod"
	"github.com/googleapis/gnostic v0.0.0-20170729233727-0c5108395e2d/go.mod"
	"github.com/googleapis/gnostic v0.1.0/go.mod"
	"github.com/gophercloud/gophercloud v0.1.0/go.mod"
	"github.com/gophercloud/gophercloud v0.3.0/go.mod"
	"github.com/gophercloud/gophercloud v0.9.0/go.mod"
	"github.com/gopherjs/gopherjs v0.0.0-20181017120253-0766667cb4d1/go.mod"
	"github.com/gorilla/context v1.1.1/go.mod"
	"github.com/gorilla/mux v1.6.2/go.mod"
	"github.com/gorilla/mux v1.7.3/go.mod"
	"github.com/gorilla/websocket v0.0.0-20170926233335-4201258b820c/go.mod"
	"github.com/gorilla/websocket v1.4.0/go.mod"
	"github.com/gregjones/httpcache v0.0.0-20180305231024-9cad4c3443a7/go.mod"
	"github.com/grpc-ecosystem/go-grpc-middleware v1.0.1-0.20190118093823-f849b5445de4/go.mod"
	"github.com/grpc-ecosystem/go-grpc-prometheus v1.2.0/go.mod"
	"github.com/grpc-ecosystem/grpc-gateway v1.8.5/go.mod"
	"github.com/grpc-ecosystem/grpc-gateway v1.9.5/go.mod"
	"github.com/grpc-ecosystem/grpc-opentracing v0.0.0-20180507213350-8e809c8a8645/go.mod"
	"github.com/h2non/parth v0.0.0-20190131123155-b4df798d6542/go.mod"
	"github.com/hashicorp/go-syslog v1.0.0/go.mod"
	"github.com/hashicorp/golang-lru v0.5.0/go.mod"
	"github.com/hashicorp/golang-lru v0.5.1/go.mod"
	"github.com/hashicorp/golang-lru v0.5.3/go.mod"
	"github.com/hashicorp/golang-lru v0.5.4/go.mod"
	"github.com/hpcloud/tail v1.0.0/go.mod"
	"github.com/ianlancetaylor/demangle v0.0.0-20181102032728-5e5cf60278f6/go.mod"
	"github.com/iij/doapi v0.0.0-20190504054126-0bbf12d6d7df/go.mod"
	"github.com/imdario/mergo v0.3.5/go.mod"
	"github.com/imdario/mergo v0.3.9/go.mod"
	"github.com/inconshreveable/mousetrap v1.0.0/go.mod"
	"github.com/infobloxopen/go-trees v0.0.0-20190313150506-2af4e13f9062/go.mod"
	"github.com/jimstudt/http-authentication v0.0.0-20140401203705-3eca13d6893a/go.mod"
	"github.com/jmespath/go-jmespath v0.0.0-20180206201540-c2b33e8439af/go.mod"
	"github.com/jmespath/go-jmespath v0.3.0/go.mod"
	"github.com/jonboulle/clockwork v0.1.0/go.mod"
	"github.com/json-iterator/go v1.1.5/go.mod"
	"github.com/json-iterator/go v1.1.6/go.mod"
	"github.com/json-iterator/go v1.1.7/go.mod"
	"github.com/json-iterator/go v1.1.8/go.mod"
	"github.com/json-iterator/go v1.1.9/go.mod"
	"github.com/jstemmer/go-junit-report v0.0.0-20190106144839-af01ea7f8024/go.mod"
	"github.com/jstemmer/go-junit-report v0.9.1/go.mod"
	"github.com/jtolds/gls v4.20.0+incompatible/go.mod"
	"github.com/julienschmidt/httprouter v1.2.0/go.mod"
	"github.com/kisielk/errcheck v1.1.0/go.mod"
	"github.com/kisielk/errcheck v1.2.0/go.mod"
	"github.com/kisielk/gotool v1.0.0/go.mod"
	"github.com/klauspost/cpuid v1.2.0/go.mod"
	"github.com/kolo/xmlrpc v0.0.0-20190717152603-07c4ee3fd181/go.mod"
	"github.com/konsorten/go-windows-terminal-sequences v1.0.1/go.mod"
	"github.com/konsorten/go-windows-terminal-sequences v1.0.2/go.mod"
	"github.com/kr/logfmt v0.0.0-20140226030751-b84e30acd515/go.mod"
	"github.com/kr/pretty v0.1.0/go.mod"
	"github.com/kr/pretty v0.2.0/go.mod"
	"github.com/kr/pty v1.1.1/go.mod"
	"github.com/kr/text v0.1.0/go.mod"
	"github.com/kylelemons/godebug v0.0.0-20170820004349-d65d576e9348/go.mod"
	"github.com/labbsr0x/bindman-dns-webhook v1.0.2/go.mod"
	"github.com/labbsr0x/goh v1.0.1/go.mod"
	"github.com/linode/linodego v0.10.0/go.mod"
	"github.com/liquidweb/liquidweb-go v1.6.0/go.mod"
	"github.com/lucas-clemente/quic-go v0.13.1/go.mod"
	"github.com/mailru/easyjson v0.0.0-20160728113105-d5b7844b561a/go.mod"
	"github.com/marten-seemann/chacha20 v0.2.0/go.mod"
	"github.com/marten-seemann/qpack v0.1.0/go.mod"
	"github.com/marten-seemann/qtls v0.4.1/go.mod"
	"github.com/mattn/go-colorable v0.0.9/go.mod"
	"github.com/mattn/go-isatty v0.0.3/go.mod"
	"github.com/mattn/go-isatty v0.0.4/go.mod"
	"github.com/mattn/go-runewidth v0.0.2/go.mod"
	"github.com/mattn/go-runewidth v0.0.4/go.mod"
	"github.com/mattn/go-tty v0.0.0-20180219170247-931426f7535a/go.mod"
	"github.com/matttproud/golang_protobuf_extensions v1.0.1/go.mod"
	"github.com/mholt/certmagic v0.8.3/go.mod"
	"github.com/miekg/dns v1.1.15/go.mod"
	"github.com/miekg/dns v1.1.29/go.mod"
	"github.com/mitchellh/go-homedir v1.1.0/go.mod"
	"github.com/mitchellh/go-vnc v0.0.0-20150629162542-723ed9867aed/go.mod"
	"github.com/mitchellh/mapstructure v1.1.2/go.mod"
	"github.com/modern-go/concurrent v0.0.0-20180228061459-e0a39a4cb421/go.mod"
	"github.com/modern-go/concurrent v0.0.0-20180306012644-bacd9c7ef1dd/go.mod"
	"github.com/modern-go/reflect2 v0.0.0-20180701023420-4b7aa43c6742/go.mod"
	"github.com/modern-go/reflect2 v1.0.1/go.mod"
	"github.com/munnerz/goautoneg v0.0.0-20120707110453-a547fc61f48d/go.mod"
	"github.com/mwitkow/go-conntrack v0.0.0-20161129095857-cc309e4a2223/go.mod"
	"github.com/mxk/go-flowrate v0.0.0-20140419014527-cca7078d478f/go.mod"
	"github.com/namedotcom/go v0.0.0-20180403034216-08470befbe04/go.mod"
	"github.com/naoina/go-stringutil v0.1.0/go.mod"
	"github.com/naoina/toml v0.1.1/go.mod"
	"github.com/nbio/st v0.0.0-20140626010706-e9e8d9816f32/go.mod"
	"github.com/nrdcg/auroradns v1.0.0/go.mod"
	"github.com/nrdcg/goinwx v0.6.1/go.mod"
	"github.com/nrdcg/namesilo v0.2.1/go.mod"
	"github.com/olekukonko/tablewriter v0.0.0-20170122224234-a0225b3f23b5/go.mod"
	"github.com/olekukonko/tablewriter v0.0.1/go.mod"
	"github.com/onsi/ginkgo v0.0.0-20170829012221-11459a886d9c/go.mod"
	"github.com/onsi/ginkgo v1.6.0/go.mod"
	"github.com/onsi/ginkgo v1.7.0/go.mod"
	"github.com/onsi/ginkgo v1.11.0/go.mod"
	"github.com/onsi/gomega v0.0.0-20170829124025-dcabb60a477c/go.mod"
	"github.com/onsi/gomega v1.4.3/go.mod"
	"github.com/onsi/gomega v1.7.0/go.mod"
	"github.com/opentracing-contrib/go-observer v0.0.0-20170622124052-a52f23424492/go.mod"
	"github.com/opentracing/opentracing-go v1.1.0/go.mod"
	"github.com/openzipkin-contrib/zipkin-go-opentracing v0.3.5/go.mod"
	"github.com/openzipkin/zipkin-go v0.1.6/go.mod"
	"github.com/oracle/oci-go-sdk v7.0.0+incompatible/go.mod"
	"github.com/ovh/go-ovh v0.0.0-20181109152953-ba5adb4cf014/go.mod"
	"github.com/peterbourgon/diskv v2.0.1+incompatible/go.mod"
	"github.com/philhofer/fwd v1.0.0/go.mod"
	"github.com/pierrec/lz4 v2.0.5+incompatible/go.mod"
	"github.com/pkg/errors v0.8.0/go.mod"
	"github.com/pkg/errors v0.8.1/go.mod"
	"github.com/pkg/errors v0.9.1/go.mod"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/prometheus/client_golang v0.9.1/go.mod"
	"github.com/prometheus/client_golang v0.9.3-0.20190127221311-3c4408c8b829/go.mod"
	"github.com/prometheus/client_golang v1.0.0/go.mod"
	"github.com/prometheus/client_golang v1.1.0/go.mod"
	"github.com/prometheus/client_golang v1.6.0/go.mod"
	"github.com/prometheus/client_model v0.0.0-20180712105110-5c3871d89910/go.mod"
	"github.com/prometheus/client_model v0.0.0-20190115171406-56726106282f/go.mod"
	"github.com/prometheus/client_model v0.0.0-20190129233127-fd36f4220a90/go.mod"
	"github.com/prometheus/client_model v0.0.0-20190812154241-14fe0d1b01d4/go.mod"
	"github.com/prometheus/client_model v0.2.0/go.mod"
	"github.com/prometheus/common v0.2.0/go.mod"
	"github.com/prometheus/common v0.4.1/go.mod"
	"github.com/prometheus/common v0.6.0/go.mod"
	"github.com/prometheus/common v0.9.1/go.mod"
	"github.com/prometheus/common v0.10.0/go.mod"
	"github.com/prometheus/procfs v0.0.0-20181005140218-185b4288413d/go.mod"
	"github.com/prometheus/procfs v0.0.0-20190117184657-bf6a532e95b1/go.mod"
	"github.com/prometheus/procfs v0.0.2/go.mod"
	"github.com/prometheus/procfs v0.0.3/go.mod"
	"github.com/prometheus/procfs v0.0.11/go.mod"
	"github.com/prometheus/prometheus v2.5.0+incompatible/go.mod"
	"github.com/rainycape/memcache v0.0.0-20150622160815-1031fa0ce2f2/go.mod"
	"github.com/rcrowley/go-metrics v0.0.0-20181016184325-3113b8401b8a/go.mod"
	"github.com/rogpeppe/fastuuid v0.0.0-20150106093220-6724a57986af/go.mod"
	"github.com/rogpeppe/go-internal v1.3.0/go.mod"
	"github.com/russross/blackfriday v0.0.0-20170610170232-067529f716f4/go.mod"
	"github.com/russross/blackfriday/v2 v2.0.1/go.mod"
	"github.com/sacloud/libsacloud v1.26.1/go.mod"
	"github.com/satori/go.uuid v1.2.0/go.mod"
	"github.com/shurcooL/sanitized_anchor_name v1.0.0/go.mod"
	"github.com/sirupsen/logrus v1.2.0/go.mod"
	"github.com/sirupsen/logrus v1.4.2/go.mod"
	"github.com/skratchdot/open-golang v0.0.0-20160302144031-75fb7ed4208c/go.mod"
	"github.com/smartystreets/assertions v0.0.0-20180927180507-b2de0cb4f26d/go.mod"
	"github.com/smartystreets/goconvey v0.0.0-20190330032615-68dc04aab96a/go.mod"
	"github.com/soheilhy/cmux v0.1.4/go.mod"
	"github.com/spf13/afero v1.2.2/go.mod"
	"github.com/spf13/cobra v0.0.3/go.mod"
	"github.com/spf13/pflag v0.0.0-20170130214245-9ff6c6923cff/go.mod"
	"github.com/spf13/pflag v1.0.1/go.mod"
	"github.com/spf13/pflag v1.0.5/go.mod"
	"github.com/stretchr/objx v0.1.0/go.mod"
	"github.com/stretchr/objx v0.1.1/go.mod"
	"github.com/stretchr/testify v1.2.2/go.mod"
	"github.com/stretchr/testify v1.3.0/go.mod"
	"github.com/stretchr/testify v1.4.0/go.mod"
	"github.com/stretchr/testify v1.5.1/go.mod"
	"github.com/timewasted/linode v0.0.0-20160829202747-37e84520dcf7/go.mod"
	"github.com/tinylib/msgp v1.1.2/go.mod"
	"github.com/tmc/grpc-websocket-proxy v0.0.0-20170815181823-89b8d40f7ca8/go.mod"
	"github.com/transip/gotransip v0.0.0-20190812104329-6d8d9179b66f/go.mod"
	"github.com/uber-go/atomic v1.3.2/go.mod"
	"github.com/urfave/cli v1.20.0/go.mod"
	"github.com/urfave/cli v1.22.1/go.mod"
	"github.com/vultr/govultr v0.1.4/go.mod"
	"github.com/xeipuuv/gojsonpointer v0.0.0-20180127040702-4e3ac2762d5f/go.mod"
	"github.com/xeipuuv/gojsonreference v0.0.0-20180127040603-bd5ef7bd5415/go.mod"
	"github.com/xeipuuv/gojsonschema v1.1.0/go.mod"
	"github.com/xiang90/probing v0.0.0-20190116061207-43a291ad63a2/go.mod"
	"github.com/yuin/goldmark v1.1.25/go.mod"
	"go.etcd.io/bbolt v1.3.3/go.mod"
	"go.etcd.io/etcd v0.5.0-alpha.5.0.20200306183522-221f0cc107cb/go.mod"
	"go.opencensus.io v0.20.1/go.mod"
	"go.opencensus.io v0.20.2/go.mod"
	"go.opencensus.io v0.21.0/go.mod"
	"go.opencensus.io v0.22.0/go.mod"
	"go.opencensus.io v0.22.2/go.mod"
	"go.opencensus.io v0.22.3/go.mod"
	"go.uber.org/atomic v1.3.2/go.mod"
	"go.uber.org/atomic v1.6.0/go.mod"
	"go.uber.org/multierr v1.1.0/go.mod"
	"go.uber.org/multierr v1.5.0/go.mod"
	"go.uber.org/ratelimit v0.0.0-20180316092928-c15da0234277/go.mod"
	"go.uber.org/tools v0.0.0-20190618225709-2cfd321de3ee/go.mod"
	"go.uber.org/zap v1.10.0/go.mod"
	"go.uber.org/zap v1.14.1/go.mod"
	"golang.org/x/crypto v0.0.0-20180621125126-a49355c7e3f8/go.mod"
	"golang.org/x/crypto v0.0.0-20180904163835-0709b304e793/go.mod"
	"golang.org/x/crypto v0.0.0-20190211182817-74369b46fc67/go.mod"
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
	"golang.org/x/crypto v0.0.0-20190418165655-df01cb2cc480/go.mod"
	"golang.org/x/crypto v0.0.0-20190510104115-cbcb75029529/go.mod"
	"golang.org/x/crypto v0.0.0-20190605123033-f99c8df09eb5/go.mod"
	"golang.org/x/crypto v0.0.0-20190701094942-4def268fd1a4/go.mod"
	"golang.org/x/crypto v0.0.0-20190829043050-9756ffdc2472/go.mod"
	"golang.org/x/crypto v0.0.0-20190911031432-227b76d455e7/go.mod"
	"golang.org/x/crypto v0.0.0-20191002192127-34f69633bfdc/go.mod"
	"golang.org/x/crypto v0.0.0-20191011191535-87dc89f01550/go.mod"
	"golang.org/x/crypto v0.0.0-20191202143827-86a70503ff7e/go.mod"
	"golang.org/x/crypto v0.0.0-20191206172530-e9b2fee46413/go.mod"
	"golang.org/x/crypto v0.0.0-20200220183623-bac4c82f6975/go.mod"
	"golang.org/x/crypto v0.0.0-20200323165209-0ec3e9974c59/go.mod"
	"golang.org/x/exp v0.0.0-20190121172915-509febef88a4/go.mod"
	"golang.org/x/exp v0.0.0-20190306152737-a1d7652674e8/go.mod"
	"golang.org/x/exp v0.0.0-20190510132918-efd6b22b2522/go.mod"
	"golang.org/x/exp v0.0.0-20190829153037-c13cbed26979/go.mod"
	"golang.org/x/exp v0.0.0-20191030013958-a1ab85dbe136/go.mod"
	"golang.org/x/exp v0.0.0-20191129062945-2f5052295587/go.mod"
	"golang.org/x/exp v0.0.0-20191227195350-da58074b4299/go.mod"
	"golang.org/x/exp v0.0.0-20200119233911-0405dc783f0a/go.mod"
	"golang.org/x/exp v0.0.0-20200207192155-f17229e696bd/go.mod"
	"golang.org/x/exp v0.0.0-20200224162631-6cc2880d07d6/go.mod"
	"golang.org/x/image v0.0.0-20190227222117-0694c2d4d067/go.mod"
	"golang.org/x/image v0.0.0-20190802002840-cff245a6509b/go.mod"
	"golang.org/x/lint v0.0.0-20181026193005-c67002cb31c3/go.mod"
	"golang.org/x/lint v0.0.0-20190227174305-5b3e6a55c961/go.mod"
	"golang.org/x/lint v0.0.0-20190301231843-5614ed5bae6f/go.mod"
	"golang.org/x/lint v0.0.0-20190313153728-d0100b6bd8b3/go.mod"
	"golang.org/x/lint v0.0.0-20190409202823-959b441ac422/go.mod"
	"golang.org/x/lint v0.0.0-20190909230951-414d861bb4ac/go.mod"
	"golang.org/x/lint v0.0.0-20190930215403-16217165b5de/go.mod"
	"golang.org/x/lint v0.0.0-20191125180803-fdd1cda4f05f/go.mod"
	"golang.org/x/lint v0.0.0-20200130185559-910be7a94367/go.mod"
	"golang.org/x/lint v0.0.0-20200302205851-738671d3881b/go.mod"
	"golang.org/x/mobile v0.0.0-20190312151609-d3739f865fa6/go.mod"
	"golang.org/x/mobile v0.0.0-20190719004257-d2bd2a29d028/go.mod"
	"golang.org/x/mod v0.0.0-20190513183733-4bf6d317e70e/go.mod"
	"golang.org/x/mod v0.1.0/go.mod"
	"golang.org/x/mod v0.1.1-0.20191105210325-c90efee705ee/go.mod"
	"golang.org/x/mod v0.1.1-0.20191107180719-034126e5016b/go.mod"
	"golang.org/x/mod v0.2.0/go.mod"
	"golang.org/x/net v0.0.0-20170114055629-f2499483f923/go.mod"
	"golang.org/x/net v0.0.0-20180611182652-db08ff08e862/go.mod"
	"golang.org/x/net v0.0.0-20180724234803-3673e40ba225/go.mod"
	"golang.org/x/net v0.0.0-20180826012351-8a410e7b638d/go.mod"
	"golang.org/x/net v0.0.0-20180906233101-161cd47e91fd/go.mod"
	"golang.org/x/net v0.0.0-20181114220301-adae6a3d119a/go.mod"
	"golang.org/x/net v0.0.0-20181220203305-927f97764cc3/go.mod"
	"golang.org/x/net v0.0.0-20190108225652-1e06a53dbb7e/go.mod"
	"golang.org/x/net v0.0.0-20190125091013-d26f9f9a57f3/go.mod"
	"golang.org/x/net v0.0.0-20190213061140-3a22650c66bd/go.mod"
	"golang.org/x/net v0.0.0-20190228165749-92fc7df08ae7/go.mod"
	"golang.org/x/net v0.0.0-20190311183353-d8887717615a/go.mod"
	"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod"
	"golang.org/x/net v0.0.0-20190501004415-9ce7a6920f09/go.mod"
	"golang.org/x/net v0.0.0-20190503192946-f4e77d36d62c/go.mod"
	"golang.org/x/net v0.0.0-20190603091049-60506f45cf65/go.mod"
	"golang.org/x/net v0.0.0-20190613194153-d28f0bde5980/go.mod"
	"golang.org/x/net v0.0.0-20190620200207-3b0461eec859/go.mod"
	"golang.org/x/net v0.0.0-20190724013045-ca1201d0de80/go.mod"
	"golang.org/x/net v0.0.0-20190813141303-74dc4d7220e7/go.mod"
	"golang.org/x/net v0.0.0-20190923162816-aa69164e4478/go.mod"
	"golang.org/x/net v0.0.0-20190930134127-c5a3c61f89f3/go.mod"
	"golang.org/x/net v0.0.0-20191004110552-13f9640d40b9/go.mod"
	"golang.org/x/net v0.0.0-20191027093000-83d349e8ac1a/go.mod"
	"golang.org/x/net v0.0.0-20191126235420-ef20fe5d7933/go.mod"
	"golang.org/x/net v0.0.0-20191209160850-c0dbc17a3553/go.mod"
	"golang.org/x/net v0.0.0-20200114155413-6afb5195e5aa/go.mod"
	"golang.org/x/net v0.0.0-20200202094626-16171245cfb2/go.mod"
	"golang.org/x/net v0.0.0-20200222125558-5a598a2470a0/go.mod"
	"golang.org/x/net v0.0.0-20200226121028-0de0cce0169b/go.mod"
	"golang.org/x/net v0.0.0-20200324143707-d3edc9973b7e/go.mod"
	"golang.org/x/oauth2 v0.0.0-20180821212333-d2e6202438be/go.mod"
	"golang.org/x/oauth2 v0.0.0-20190226205417-e64efc72b421/go.mod"
	"golang.org/x/oauth2 v0.0.0-20190604053449-0f29369cfe45/go.mod"
	"golang.org/x/oauth2 v0.0.0-20191202225959-858c2ad4c8b6/go.mod"
	"golang.org/x/oauth2 v0.0.0-20200107190931-bf48bf16ab8d/go.mod"
	"golang.org/x/sync v0.0.0-20180314180146-1d60e4601c6f/go.mod"
	"golang.org/x/sync v0.0.0-20181108010431-42b317875d0f/go.mod"
	"golang.org/x/sync v0.0.0-20181221193216-37e7f081c4d4/go.mod"
	"golang.org/x/sync v0.0.0-20190227155943-e225da77a7e6/go.mod"
	"golang.org/x/sync v0.0.0-20190423024810-112230192c58/go.mod"
	"golang.org/x/sync v0.0.0-20190911185100-cd5d95a43a6e/go.mod"
	"golang.org/x/sync v0.0.0-20200317015054-43a5402ce75a/go.mod"
	"golang.org/x/sys v0.0.0-20170830134202-bb24a47a89ea/go.mod"
	"golang.org/x/sys v0.0.0-20180622082034-63fc586f45fe/go.mod"
	"golang.org/x/sys v0.0.0-20180830151530-49385e6e1522/go.mod"
	"golang.org/x/sys v0.0.0-20180905080454-ebe1bf3edb33/go.mod"
	"golang.org/x/sys v0.0.0-20180909124046-d0be0721c37e/go.mod"
	"golang.org/x/sys v0.0.0-20181107165924-66b7b1311ac8/go.mod"
	"golang.org/x/sys v0.0.0-20181116152217-5ac8a444bdc5/go.mod"
	"golang.org/x/sys v0.0.0-20181122145206-62eef0e2fa9b/go.mod"
	"golang.org/x/sys v0.0.0-20190209173611-3b5209105503/go.mod"
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
	"golang.org/x/sys v0.0.0-20190312061237-fead79001313/go.mod"
	"golang.org/x/sys v0.0.0-20190403152447-81d4e9dc473e/go.mod"
	"golang.org/x/sys v0.0.0-20190412213103-97732733099d/go.mod"
	"golang.org/x/sys v0.0.0-20190422165155-953cdadca894/go.mod"
	"golang.org/x/sys v0.0.0-20190502145724-3ef323f4f1fd/go.mod"
	"golang.org/x/sys v0.0.0-20190507160741-ecd444e8653b/go.mod"
	"golang.org/x/sys v0.0.0-20190606165138-5da285871e9c/go.mod"
	"golang.org/x/sys v0.0.0-20190624142023-c5567b49c5d0/go.mod"
	"golang.org/x/sys v0.0.0-20190726091711-fc99dfbffb4e/go.mod"
	"golang.org/x/sys v0.0.0-20190801041406-cbf593c0f2f3/go.mod"
	"golang.org/x/sys v0.0.0-20190826190057-c7b8b68b1456/go.mod"
	"golang.org/x/sys v0.0.0-20190904154756-749cb33beabd/go.mod"
	"golang.org/x/sys v0.0.0-20190924154521-2837fb4f24fe/go.mod"
	"golang.org/x/sys v0.0.0-20191001151750-bb3f8db39f24/go.mod"
	"golang.org/x/sys v0.0.0-20191022100944-742c48ecaeb7/go.mod"
	"golang.org/x/sys v0.0.0-20191026070338-33540a1f6037/go.mod"
	"golang.org/x/sys v0.0.0-20191128015809-6d18c012aee9/go.mod"
	"golang.org/x/sys v0.0.0-20191204072324-ce4227a45e2e/go.mod"
	"golang.org/x/sys v0.0.0-20191228213918-04cbcbbfeed8/go.mod"
	"golang.org/x/sys v0.0.0-20200106162015-b016eb3dc98e/go.mod"
	"golang.org/x/sys v0.0.0-20200113162924-86b910548bc1/go.mod"
	"golang.org/x/sys v0.0.0-20200122134326-e047566fdf82/go.mod"
	"golang.org/x/sys v0.0.0-20200202164722-d101bd2416d5/go.mod"
	"golang.org/x/sys v0.0.0-20200212091648-12a6c2dcc1e4/go.mod"
	"golang.org/x/sys v0.0.0-20200223170610-d5e6a3e2c0ae/go.mod"
	"golang.org/x/sys v0.0.0-20200323222414-85ca7c5b95cd/go.mod"
	"golang.org/x/sys v0.0.0-20200331124033-c3d80250170d/go.mod"
	"golang.org/x/sys v0.0.0-20200420163511-1957bb5e6d1f/go.mod"
	"golang.org/x/text v0.0.0-20160726164857-2910a502d2bf/go.mod"
	"golang.org/x/text v0.0.0-20170915032832-14c0d48ead0c/go.mod"
	"golang.org/x/text v0.3.0/go.mod"
	"golang.org/x/text v0.3.1-0.20180807135948-17ff2d5776d2/go.mod"
	"golang.org/x/text v0.3.2/go.mod"
	"golang.org/x/time v0.0.0-20180412165947-fbb02b2291d2/go.mod"
	"golang.org/x/time v0.0.0-20181108054448-85acf8d2951c/go.mod"
	"golang.org/x/time v0.0.0-20190308202827-9d24e82272b4/go.mod"
	"golang.org/x/time v0.0.0-20190921001708-c4c64cad1fd0/go.mod"
	"golang.org/x/time v0.0.0-20191024005414-555d28b269f0/go.mod"
	"golang.org/x/tools v0.0.0-20180221164845-07fd8470d635/go.mod"
	"golang.org/x/tools v0.0.0-20180828015842-6cd1fcedba52/go.mod"
	"golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod"
	"golang.org/x/tools v0.0.0-20181011042414-1f849cf54d09/go.mod"
	"golang.org/x/tools v0.0.0-20181030221726-6c7e314b6563/go.mod"
	"golang.org/x/tools v0.0.0-20190114222345-bf090417da8b/go.mod"
	"golang.org/x/tools v0.0.0-20190226205152-f727befe758c/go.mod"
	"golang.org/x/tools v0.0.0-20190311212946-11955173bddd/go.mod"
	"golang.org/x/tools v0.0.0-20190312151545-0bb0c0a6e846/go.mod"
	"golang.org/x/tools v0.0.0-20190312170243-e65039ee4138/go.mod"
	"golang.org/x/tools v0.0.0-20190328211700-ab21143f2384/go.mod"
	"golang.org/x/tools v0.0.0-20190425150028-36563e24a262/go.mod"
	"golang.org/x/tools v0.0.0-20190506145303-2d16b83fe98c/go.mod"
	"golang.org/x/tools v0.0.0-20190524140312-2c0ae7006135/go.mod"
	"golang.org/x/tools v0.0.0-20190606124116-d0a3d012864b/go.mod"
	"golang.org/x/tools v0.0.0-20190621195816-6e04913cbbac/go.mod"
	"golang.org/x/tools v0.0.0-20190628153133-6cdbf07be9d0/go.mod"
	"golang.org/x/tools v0.0.0-20190816200558-6889da9d5479/go.mod"
	"golang.org/x/tools v0.0.0-20190911174233-4f2ddba30aff/go.mod"
	"golang.org/x/tools v0.0.0-20191012152004-8de300cfc20a/go.mod"
	"golang.org/x/tools v0.0.0-20191029041327-9cc4af7d6b2c/go.mod"
	"golang.org/x/tools v0.0.0-20191029190741-b9c20aec41a5/go.mod"
	"golang.org/x/tools v0.0.0-20191113191852-77e3bb0ad9e7/go.mod"
	"golang.org/x/tools v0.0.0-20191115202509-3a792d9c32b2/go.mod"
	"golang.org/x/tools v0.0.0-20191119224855-298f0cb1881e/go.mod"
	"golang.org/x/tools v0.0.0-20191125144606-a911d9008d1f/go.mod"
	"golang.org/x/tools v0.0.0-20191130070609-6e064ea0cf2d/go.mod"
	"golang.org/x/tools v0.0.0-20191203134012-c197fd4bf371/go.mod"
	"golang.org/x/tools v0.0.0-20191216052735-49a3e744a425/go.mod"
	"golang.org/x/tools v0.0.0-20191216173652-a0e659d51361/go.mod"
	"golang.org/x/tools v0.0.0-20191227053925-7b8e75db28f4/go.mod"
	"golang.org/x/tools v0.0.0-20200117161641-43d50277825c/go.mod"
	"golang.org/x/tools v0.0.0-20200122220014-bf1340f18c4a/go.mod"
	"golang.org/x/tools v0.0.0-20200130002326-2f3ba24bd6e7/go.mod"
	"golang.org/x/tools v0.0.0-20200204074204-1cc6d1ef6c74/go.mod"
	"golang.org/x/tools v0.0.0-20200207183749-b753a1ba74fa/go.mod"
	"golang.org/x/tools v0.0.0-20200212150539-ea181f53ac56/go.mod"
	"golang.org/x/tools v0.0.0-20200224181240-023911ca70b2/go.mod"
	"golang.org/x/tools v0.0.0-20200331025713-a30bf2db82d4/go.mod"
	"golang.org/x/xerrors v0.0.0-20190717185122-a985d3407aa7/go.mod"
	"golang.org/x/xerrors v0.0.0-20191011141410-1b5146add898/go.mod"
	"golang.org/x/xerrors v0.0.0-20191204190536-9bdfabe68543/go.mod"
	"google.golang.org/api v0.3.1/go.mod"
	"google.golang.org/api v0.4.0/go.mod"
	"google.golang.org/api v0.7.0/go.mod"
	"google.golang.org/api v0.8.0/go.mod"
	"google.golang.org/api v0.9.0/go.mod"
	"google.golang.org/api v0.13.0/go.mod"
	"google.golang.org/api v0.14.0/go.mod"
	"google.golang.org/api v0.15.0/go.mod"
	"google.golang.org/api v0.17.0/go.mod"
	"google.golang.org/api v0.18.0/go.mod"
	"google.golang.org/api v0.20.0/go.mod"
	"google.golang.org/api v0.26.0/go.mod"
	"google.golang.org/appengine v1.1.0/go.mod"
	"google.golang.org/appengine v1.4.0/go.mod"
	"google.golang.org/appengine v1.5.0/go.mod"
	"google.golang.org/appengine v1.6.1/go.mod"
	"google.golang.org/appengine v1.6.5/go.mod"
	"google.golang.org/genproto v0.0.0-20180817151627-c66870c02cf8/go.mod"
	"google.golang.org/genproto v0.0.0-20180831171423-11092d34479b/go.mod"
	"google.golang.org/genproto v0.0.0-20190307195333-5fe7a883aa19/go.mod"
	"google.golang.org/genproto v0.0.0-20190418145605-e7d98fc518a7/go.mod"
	"google.golang.org/genproto v0.0.0-20190425155659-357c62f0e4bb/go.mod"
	"google.golang.org/genproto v0.0.0-20190502173448-54afdca5d873/go.mod"
	"google.golang.org/genproto v0.0.0-20190801165951-fa694d86fc64/go.mod"
	"google.golang.org/genproto v0.0.0-20190819201941-24fa4b261c55/go.mod"
	"google.golang.org/genproto v0.0.0-20190911173649-1774047e7e51/go.mod"
	"google.golang.org/genproto v0.0.0-20191108220845-16a3f7862a1a/go.mod"
	"google.golang.org/genproto v0.0.0-20191115194625-c23dd37a84c9/go.mod"
	"google.golang.org/genproto v0.0.0-20191216164720-4f79533eabd1/go.mod"
	"google.golang.org/genproto v0.0.0-20191230161307-f3c370f40bfb/go.mod"
	"google.golang.org/genproto v0.0.0-20200115191322-ca5a22157cba/go.mod"
	"google.golang.org/genproto v0.0.0-20200122232147-0452cf42e150/go.mod"
	"google.golang.org/genproto v0.0.0-20200204135345-fa8e72b47b90/go.mod"
	"google.golang.org/genproto v0.0.0-20200212174721-66ed5ce911ce/go.mod"
	"google.golang.org/genproto v0.0.0-20200224152610-e50cd9704f63/go.mod"
	"google.golang.org/genproto v0.0.0-20200331122359-1ee6d9798940/go.mod"
	"google.golang.org/grpc v1.17.0/go.mod"
	"google.golang.org/grpc v1.19.0/go.mod"
	"google.golang.org/grpc v1.19.1/go.mod"
	"google.golang.org/grpc v1.20.1/go.mod"
	"google.golang.org/grpc v1.21.1/go.mod"
	"google.golang.org/grpc v1.23.0/go.mod"
	"google.golang.org/grpc v1.25.1/go.mod"
	"google.golang.org/grpc v1.26.0/go.mod"
	"google.golang.org/grpc v1.27.0/go.mod"
	"google.golang.org/grpc v1.27.1/go.mod"
	"google.golang.org/grpc v1.28.0/go.mod"
	"google.golang.org/grpc v1.29.1/go.mod"
	"google.golang.org/protobuf v0.0.0-20200109180630-ec00e32a8dfd/go.mod"
	"google.golang.org/protobuf v0.0.0-20200221191635-4d8936d0db64/go.mod"
	"google.golang.org/protobuf v0.0.0-20200228230310-ab0ca4ff8a60/go.mod"
	"google.golang.org/protobuf v1.20.1-0.20200309200217-e05f789c0967/go.mod"
	"google.golang.org/protobuf v1.21.0/go.mod"
	"google.golang.org/protobuf v1.23.0/go.mod"
	"gopkg.in/DataDog/dd-trace-go.v1 v1.24.1/go.mod"
	"gopkg.in/alecthomas/kingpin.v2 v2.2.6/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/check.v1 v1.0.0-20180628173108-788fd7840127/go.mod"
	"gopkg.in/check.v1 v1.0.0-20190902080502-41f04d3bba15/go.mod"
	"gopkg.in/cheggaaa/pb.v1 v1.0.25/go.mod"
	"gopkg.in/errgo.v2 v2.1.0/go.mod"
	"gopkg.in/fsnotify.v1 v1.4.7/go.mod"
	"gopkg.in/h2non/gock.v1 v1.0.15/go.mod"
	"gopkg.in/inf.v0 v0.9.1/go.mod"
	"gopkg.in/ini.v1 v1.42.0/go.mod"
	"gopkg.in/ini.v1 v1.44.0/go.mod"
	"gopkg.in/mcuadros/go-syslog.v2 v2.2.1/go.mod"
	"gopkg.in/natefinch/lumberjack.v2 v2.0.0/go.mod"
	"gopkg.in/ns1/ns1-go.v2 v2.0.0-20190730140822-b51389932cbc/go.mod"
	"gopkg.in/resty.v1 v1.9.1/go.mod"
	"gopkg.in/resty.v1 v1.12.0/go.mod"
	"gopkg.in/square/go-jose.v2 v2.3.1/go.mod"
	"gopkg.in/tomb.v1 v1.0.0-20141024135613-dd632973f1e7/go.mod"
	"gopkg.in/yaml.v2 v2.0.0-20170812160011-eb3733d160e7/go.mod"
	"gopkg.in/yaml.v2 v2.2.1/go.mod"
	"gopkg.in/yaml.v2 v2.2.2/go.mod"
	"gopkg.in/yaml.v2 v2.2.4/go.mod"
	"gopkg.in/yaml.v2 v2.2.5/go.mod"
	"gopkg.in/yaml.v2 v2.2.7/go.mod"
	"gopkg.in/yaml.v2 v2.2.8/go.mod"
	"honnef.co/go/tools v0.0.0-20180728063816-88497007e858/go.mod"
	"honnef.co/go/tools v0.0.0-20190102054323-c2f93a96b099/go.mod"
	"honnef.co/go/tools v0.0.0-20190106161140-3f1c8253044a/go.mod"
	"honnef.co/go/tools v0.0.0-20190418001031-e561f6794a2a/go.mod"
	"honnef.co/go/tools v0.0.0-20190523083050-ea95bdfd59fc/go.mod"
	"honnef.co/go/tools v0.0.1-2019.2.3/go.mod"
	"honnef.co/go/tools v0.0.1-2020.1.3/go.mod"
	"k8s.io/api v0.18.3/go.mod"
	"k8s.io/apimachinery v0.18.3/go.mod"
	"k8s.io/client-go v0.18.3/go.mod"
	"k8s.io/gengo v0.0.0-20190128074634-0689ccc1d7d6/go.mod"
	"k8s.io/klog v0.0.0-20181102134211-b9b56d5dfc92/go.mod"
	"k8s.io/klog v0.3.0/go.mod"
	"k8s.io/klog v1.0.0/go.mod"
	"k8s.io/kube-openapi v0.0.0-20200410145947-61e04a5be9a6/go.mod"
	"k8s.io/utils v0.0.0-20200324210504-a9aa75ae1b89/go.mod"
	"rsc.io/binaryregexp v0.2.0/go.mod"
	"rsc.io/quote/v3 v3.1.0/go.mod"
	"rsc.io/sampler v1.3.0/go.mod"
	"sigs.k8s.io/structured-merge-diff/v3 v3.0.0-20200116222232-67a7b8c61874/go.mod"
	"sigs.k8s.io/structured-merge-diff/v3 v3.0.0/go.mod"
	"sigs.k8s.io/yaml v1.1.0/go.mod"
	"sigs.k8s.io/yaml v1.2.0/go.mod"
)

EGO_PN="github.com/${PN}/${PN}"

inherit go-module
go-module_set_globals

ARCHIVE_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="${ARCHIVE_URI} ${EGO_SUM_SRC_URI}"

KEYWORDS="~amd64"

DESCRIPTION="A DNS server that chains middleware"
HOMEPAGE="https://github.com/coredns/coredns"

LICENSE="Apache-2.0 MIT BSD ISC MPL-2.0 BSD-2"
SLOT="0"

src_compile() {
	go build -v -ldflags="-X github.com/coredns/coredns/coremain.GitCommit=${EGIT_COMMIT}" || \
		die "go build failed"
}

src_install() {
	dobin "${PN}"
	einstalldocs
	doman man/*

	newinitd "${FILESDIR}"/coredns.initd coredns
	newconfd "${FILESDIR}"/coredns.confd coredns

	insinto /etc/coredns/
	newins "${FILESDIR}"/Corefile.example Corefile

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/coredns.logrotated coredns
}

src_test() {
	# eclass default '-x' makes tests output unreadable
	export GOFLAGS="-v -mod=readonly"

	local known_fail=(
		"TestZoneExternalCNAMELookupWithProxy"
		"TestMetricsSeveralBlocs"
		"TestMetricsAvailable"
		"TestMetricsAvailableAfterReload"
		"TestMetricsAvailableAfterReloadAndFailedReload"
	)
	# concat as '|^Test1$|^Test2$|^Test3...$':
	local known_fail_re="$(printf '|^%s$' "${known_fail[@]}")"
	# drop '|' in the begining:
	known_fail_re="${known_fail_re:1}"

	local working_tests_re="$(
		# get list of all test:
		{ GOFLAGS="-mod=readonly" go test -list . ./... ||
			die "Can't get list of tests"; } |
		# skip "no tests" messages as well as know failures:
		grep -v -E " |${known_fail_re}" |
		# format a regexp:
		sed -z 's/\n/$|^/g'
	)"
	# drop '|^' in the end:
	working_tests_re="^${working_tests_re::-2}"

	go test -race -run "${working_tests_re}" ./... || die "Tests failed"
	go test -race -run "${known_fail_re}" ./... || ewarn "Known test failure"
}
