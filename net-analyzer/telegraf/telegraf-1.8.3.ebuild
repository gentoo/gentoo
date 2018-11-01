# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/influxdata/telegraf"
EGO_VENDOR=(
	"cloud.google.com/go c728a003b238b26cef9ab6753a5dc424b331c3ad github.com/GoogleCloudPlatform/google-cloud-go"
	"code.cloudfoundry.org/clock 02e53af36e6c978af692887ed449b74026d76fec github.com/cloudfoundry/clock"
	"collectd.org 2ce144541b8903101fb8f1483cc0497a68798122 github.com/collectd/go-collectd"
	"contrib.go.opencensus.io/exporter/stackdriver 2b93072101d466aa4120b3c23c2e1b08af01541c github.com/census-ecosystem/opencensus-go-exporter-stackdriver"
	"github.com/aerospike/aerospike-client-go 1dc8cf203d24cd454e71ce40ab4cd0bf3112df90"
	"github.com/alecthomas/template a0175ee3bccc567396460bf5acd36800cb10c49c"
	"github.com/alecthomas/units 2efee857e7cfd4f3d0138cc3cbb1b4966962b93a"
	"github.com/amir/raidman 1ccc43bfb9c93cb401a4025e49c64ba71e5e668b"
	"github.com/apache/thrift f2867c24984aa53edec54a138c03db934221bdea"
	"github.com/aws/aws-sdk-go bf8067ceb6e7f51e150c218972dccfeeed892b85"
	"github.com/Azure/go-autorest 1f7cd6cfe0adea687ad44a512dfe76140f804318"
	"github.com/beorn7/perks 3a771d992973f24aa725d07868b467d1ddfceafb"
	"github.com/bsm/sarama-cluster cf455bc755fe41ac9bb2861e7a961833d9c2ecc3"
	"github.com/cenkalti/backoff 2ea60e5f094469f9e65adb9cd103795b73ae743e"
	"github.com/couchbase/go-couchbase 16db1f1fe037412f12738fa4d8448c549c4edd77"
	"github.com/couchbase/gomemcached 0da75df145308b9a4e6704d762ca9d9b77752efc"
	"github.com/couchbase/goutils e865a1461c8ac0032bd37e2d4dab3289faea3873"
	"github.com/davecgh/go-spew 346938d642f2ec3594ed81d874461961cd0faa76"
	"github.com/denisenkom/go-mssqldb 1eb28afdf9b6e56cf673badd47545f844fe81103"
	"github.com/dgrijalva/jwt-go 06ea1031745cb8b3dab3f6a236daf2b0aa468b7e"
	"github.com/dimchansky/utfbom 6c6132ff69f0f6c088739067407b5d32c52e1d0f"
	"github.com/docker/distribution edc3ab29cdff8694dd6feb85cfeb4b5f1b38ed9c"
	"github.com/docker/docker ed7b6428c133e7c59404251a09b7d6b02fa83cc2"
	"github.com/docker/go-connections 3ede32e2033de7505e6500d6c868c2b9ed9f169d"
	"github.com/docker/go-units 47565b4f722fb6ceae66b95f853feed578a4a51c"
	"github.com/docker/libnetwork d7b61745d16675c9f548b19f06fda80d422a74f0"
	"github.com/eapache/go-resiliency ea41b0fad31007accc7f806884dcdf3da98b79ce"
	"github.com/eapache/go-xerial-snappy 040cc1a32f578808623071247fdbd5cc43f37f5f"
	"github.com/eapache/queue 44cc805cf13205b55f69e14bcb69867d1ae92f98"
	"github.com/eclipse/paho.mqtt.golang 36d01c2b4cbeb3d2a12063e4880ce30800af9560"
	"github.com/gobwas/glob 5ccd90ef52e1e632236f7326478d4faa74f99438"
	"github.com/gogo/protobuf 636bf0302bc95575d69441b25a2603156ffdddf1"
	"github.com/go-ini/ini 358ee7663966325963d4e8b2e1fbd570c5195153"
	"github.com/golang/protobuf b4deda0973fb4c70b50d226b1af49f3da59f5265"
	"github.com/golang/snappy 2e65f85255dbc3072edf28d6b5b8efc472979f5a"
	"github.com/go-logfmt/logfmt 390ab7935ee28ec6b286364bba9b4dd6410cb3d5"
	"github.com/googleapis/gax-go 317e0006254c44a0ac427cc52a0e083ff0b9622f"
	"github.com/google/go-cmp 3af367b6b30c263d47e8895973edcca9a49cf029"
	"github.com/google/uuid 064e2069ce9c359c118179501254f67d7d37ba24"
	"github.com/go-ole/go-ole a41e3c4b706f6ae8dfbff342b06e40fa4d2d0506"
	"github.com/go-redis/redis 83fb42932f6145ce52df09860384a4653d2d332a"
	"github.com/gorilla/context 08b5f424b9271eedf6f9f0ce86cb9396ed337a42"
	"github.com/gorilla/mux e3702bed27f0d39777b0b37b664b6280e8ef8fbf"
	"github.com/go-sql-driver/mysql d523deb1b23d913de5bdada721a6071e71283618"
	"github.com/hailocab/go-hostpool e80d13ce29ede4452c43dea11e79b9bc8a15b478"
	"github.com/hashicorp/consul 39f93f011e591c842acc8053a7f5972aa6e592fd"
	"github.com/hashicorp/go-cleanhttp d5fe4b57a186c716b0e00b8c301cbd9b4182694d"
	"github.com/hashicorp/go-rootcerts 6bb64b370b90e7ef1fa532be9e591a81c3493e00"
	"github.com/hashicorp/serf d6574a5bb1226678d7010325fb6c985db20ee458"
	"github.com/influxdata/go-syslog eecd51df3ad85464a2bab9b7d3a45bc1e299059e"
	"github.com/influxdata/tail c43482518d410361b6c383d7aebce33d0471d7bc"
	"github.com/influxdata/toml 2a2e3012f7cfbef64091cc79776311e65dfa211b"
	"github.com/influxdata/wlog 7c63b0a71ef8300adc255344d275e10e5c3a71ec"
	"github.com/jackc/pgx da3231b0b66e2e74cdb779f1d46c5e958ba8be27"
	"github.com/jmespath/go-jmespath 0b12d6b5"
	"github.com/kardianos/osext ae77be60afb1dcacde03767a8c37337fad28ac14"
	"github.com/kardianos/service 615a14ed75099c9eaac6949e22ac2341bf9d3197"
	"github.com/kballard/go-shellquote 95032a82bc518f77982ea72343cc1ade730072f0"
	"github.com/kr/logfmt b84e30acd515aadc4b783ad4ff83aff3299bdfe0"
	"github.com/mailru/easyjson efc7eb8984d6655c26b5c9d2e65c024e5767c37c"
	"github.com/matttproud/golang_protobuf_extensions c12348ce28de40eed0136aa2b644d0ee0650e56c"
	"github.com/Microsoft/ApplicationInsights-Go d2df5d440eda5372f24fcac03839a64d6cb5f7e5"
	"github.com/Microsoft/go-winio a6d595ae73cf27a1b8fc32930668708f45ce1c85"
	"github.com/miekg/dns 5a2b9fab83ff0f8bfc99684bd5f43a37abe560f1"
	"github.com/mitchellh/go-homedir 3864e76763d94a6df2f9960b16a20a33da9f9a66"
	"github.com/mitchellh/mapstructure f15292f7a699fcc1a38a80977f80a046874ba8ac"
	"github.com/multiplay/go-ts3 d0d44555495c8776880a17e439399e715a4ef319"
	"github.com/naoina/go-stringutil 6b638e95a32d0c1131db0e7fe83775cbea4a0d0b"
	"github.com/nats-io/gnatsd 6608e9ac3be979dcb0614b772cc86a87b71acaa3"
	"github.com/nats-io/go-nats 062418ea1c2181f52dc0f954f6204370519a868b"
	"github.com/nats-io/nuid 289cccf02c178dc782430d534e3c1f5b72af807f"
	"github.com/nsqio/go-nsq eee57a3ac4174c55924125bb15eeeda8cffb6e6f"
	"github.com/opencontainers/go-digest 279bed98673dd5bef374d3b6e4b09e2af76183bf"
	"github.com/opencontainers/image-spec d60099175f88c47cd379c4738d158884749ed235"
	"github.com/opentracing-contrib/go-observer a52f2342449246d5bcc273e65cbdcfa5f7d6c63c"
	"github.com/opentracing/opentracing-go 1949ddbfd147afd4d964a9f00b24eb291e0e7c38"
	"github.com/openzipkin/zipkin-go-opentracing 26cf9707480e6b90e5eff22cf0bbf05319154232"
	"github.com/pierrec/lz4 1958fd8fff7f115e79725b1288e0b878b3e06b00"
	"github.com/pkg/errors 645ef00459ed84a119197bfb8d8205042c6df63d"
	"github.com/pmezard/go-difflib 792786c7400a136282c1664665ae0a8db921c6c2"
	"github.com/prometheus/client_golang c5b7fccd204277076155f10851dad72b76a49317"
	"github.com/prometheus/client_model 5c3871d89910bfb32f5fcab2aa4b9ec68e65a99f"
	"github.com/prometheus/common 7600349dcfe1abd18d72d3a1770870d9800a7801"
	"github.com/prometheus/procfs ae68e2d4c00fed4943b5f6698d504a5fe083da8a"
	"github.com/rcrowley/go-metrics e2704e165165ec55d062f5919b4b29494e9fa790"
	"github.com/samuel/go-zookeeper c4fab1ac1bec58281ad0667dc3f0907a9476ac47"
	"github.com/satori/go.uuid f58768cc1a7a7e77a3bd49e98cdd21419399b6a3"
	"github.com/shirou/gopsutil 8048a2e9c5773235122027dd585cf821b2af1249"
	"github.com/shirou/w32 bb4de0191aa41b5507caa14b0650cdbddcd9280b"
	"github.com/Shopify/sarama a6144ae922fd99dd0ea5046c8137acfb7fab0914"
	"github.com/sirupsen/logrus c155da19408a8799da419ed3eeb0cb5db0ad5dbc"
	"github.com/soniah/gosnmp 96b86229e9b3ffb4b954144cdc7f98fe3ee1003f"
	"github.com/StackExchange/wmi 5d049714c4a64225c3c79a7cf7d02f7fb5b96338"
	"github.com/streadway/amqp e5adc2ada8b8efff032bf61173a233d143e9318e"
	"github.com/stretchr/objx 477a77ecc69700c7cdeb1fa9e129548e1c1c393c"
	"github.com/stretchr/testify f35b8ab0b5a2cef36673838d662e249dd9c94686"
	"github.com/tidwall/gjson f123b340873a0084cb27267eddd8ff615115fbff"
	"github.com/tidwall/match 1731857f09b1f38450e2c12409748407822dc6be"
	"github.com/vishvananda/netlink b2de5d10e38ecce8607e6b438b6d174f389a004e"
	"github.com/vishvananda/netns 13995c7128ccc8e51e9a6bd2b551020a27180abd"
	"github.com/vjeantet/grok ce01e59abcf6fbc9833b7deb5e4b8ee1769bcc53"
	"github.com/vmware/govmomi e3a01f9611c32b2362366434bcd671516e78955d"
	"github.com/wvanbergen/kafka e2edea948ddfee841ea9a263b32ccca15f7d6c2f"
	"github.com/wvanbergen/kazoo-go f72d8611297a7cf105da904c04198ad701a60101"
	"github.com/yuin/gopher-lua 46796da1b0b4794e1e341883a399f12cc7574b55"
	"golang.org/x/crypto a2144134853fc9a27a7b1e3eb4f19f1a76df13c9 github.com/golang/crypto"
	"golang.org/x/net a680a1efc54dd51c040b3b5ce4939ea3cf2ea0d1 github.com/golang/net"
	"golang.org/x/oauth2 d2e6202438beef2727060aa7cabdd924d92ebfd9 github.com/golang/oauth2"
	"golang.org/x/sys ac767d655b305d4e9612f5f6e33120b9176c4ad4 github.com/golang/sys"
	"golang.org/x/text f21a4dfb5e38f5895301dc265a8def02365cc3d0 github.com/golang/text"
	"google.golang.org/api 19ff8768a5c0b8e46ea281065664787eefc24121 github.com/googleapis/google-api-go-client"
	"google.golang.org/appengine b1f26356af11148e710935ed1ac8a7f5702c7612 github.com/golang/appengine"
	"google.golang.org/genproto fedd2861243fd1a8152376292b921b394c7bef7e github.com/google/go-genproto"
	"google.golang.org/grpc 168a6198bcb0ef175f7dacec0b8691fc141dc9b8 github.com/grpc/grpc-go"
	"go.opencensus.io 79993219becaa7e29e3b60cb67f5b8e82dee11d6 github.com/census-instrumentation/opencensus-go"
	"gopkg.in/alecthomas/kingpin.v2 947dcec5ba9c011838740e680966fd7087a71d0d github.com/alecthomas/kingpin"
	"gopkg.in/asn1-ber.v1 379148ca0225df7a432012b8df0355c2a2063ac0 github.com/go-asn1-ber/asn1-ber"
	"gopkg.in/fatih/pool.v2 010e0b745d12eaf8426c95f9c3924d81dd0b668f github.com/fatih/pool"
	"gopkg.in/fsnotify.v1 c2828203cd70a50dcccfb2761f8b1f8ceef9a8e9 github.com/fsnotify/fsnotify"
	"gopkg.in/gorethink/gorethink.v3 7f5bdfd858bb064d80559b2a32b86669c5de5d3b github.com/gorethink/gorethink"
	"gopkg.in/ldap.v2 bb7a9ca6e4fbc2129e3db588a34bc970ffe811a9 github.com/go-ldap/ldap"
	"gopkg.in/mgo.v2 9856a29383ce1c59f308dd1cf0363a79b5bef6b5 github.com/go-mgo/mgo"
	"gopkg.in/olivere/elastic.v5 52741dc2ce53629cbe1e673869040d886cba2cd5 github.com/olivere/elastic"
	"gopkg.in/tomb.v1 dd632973f1e7218eb1089048e0798ec9ae7dceb8 github.com/go-tomb/tomb"
	"gopkg.in/yaml.v2 5420a8b6744d3b0345ab293f6fcba19c978f1183 github.com/go-yaml/yaml"
	)

inherit golang-build golang-vcs-snapshot systemd user

MY_PV="${PV/_rc/-rc.}"

DESCRIPTION="The plugin-driven server agent for collecting & reporting metrics."
HOMEPAGE="https://github.com/influxdata/telegraf"
SRC_URI="https://${EGO_PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

pkg_setup() {
	enewgroup telegraf
	enewuser telegraf -1 -1 -1 telegraf
}

src_compile() {
	pushd "src/${EGO_PN}" || die
	pwd
	find -iname telegraf.go
	set -- env GOPATH="${S}" go build -i -v -work -x -o telegraf \
		cmd/telegraf/telegraf.go
	echo "$@"
	"$@" || die
	popd || die
}

src_install() {
	pushd "src/${EGO_PN}" || die
	dobin telegraf
	insinto /etc/telegraf
	doins etc/telegraf.conf
	keepdir /etc/telegraf/telegraf.d

	insinto /etc/logrotate.d
	doins etc/logrotate.d/telegraf

systemd_dounit scripts/telegraf.service
	newconfd "${FILESDIR}"/telegraf.confd telegraf
	newinitd "${FILESDIR}"/telegraf.rc telegraf

	dodoc -r docs/*

	keepdir /var/log/telegraf
	fowners telegraf:telegraf /var/log/telegraf
}
