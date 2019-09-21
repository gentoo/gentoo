# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_VENDOR=( "gopkg.in/yaml.v2 51d6538a90f86fe93ac480b35f37b2be17fef232 github.com/go-yaml/yaml"
	     "gopkg.in/olivere/elastic.v5 f72acaba629a7ec879103d17b7426a31bc38e199 github.com/olivere/elastic"
	     "gopkg.in/Shopify/sarama.v1 879f631812a30a580659e8035e7cda9994bb99ac github.com/Shopify/sarama"
	     "google.golang.org/api/option bce707a4d0ea3488942724b3bcc1c8338f38f991 github.com/googleapis/google-api-go-client"
	     "google.golang.org/api/iterator bce707a4d0ea3488942724b3bcc1c8338f38f991 github.com/googleapis/google-api-go-client"
	     "google.golang.org/api/googleapi bce707a4d0ea3488942724b3bcc1c8338f38f991 github.com/googleapis/google-api-go-client"
	     "golang.org/x/time 9d24e82272b4f38b78bc8cff74fa936d31ccd8ef github.com/golang/time"
	     "golang.org/x/sys 81d4e9dc473e5e8c933f2aaeba2a3d81efb9aed2 github.com/golang/sys"
	     "golang.org/x/net eb5bcb51f2a31c7d5141d810b70815c05d9c9146 github.com/golang/net"
	     "golang.org/x/text e3703dcdd614d2d7488fff034c75c551ea25da95 github.com/golang/text"
	     "golang.org/x/crypto 38d8ce5564a5b71b2e3a00553993f1b9a7ae852f github.com/golang/crypto"
	     "go.uber.org/atomic 1ea20fb1cbb1cc08cbd0d913a96dead89aa18289 github.com/uber-go/atomic"
	     "github.com/valyala/tcplisten ceec8f93295a060cdb565ec25e4ccf17941dbd55"
	     "cloud.google.com/go/storage a4ed3b9f8c7419c692a60bbf780ab0f1c4af5ce4 github.com/googleapis/google-cloud-go"
	     "github.com/tidwall/sjson 25fb082a20e29e83fb7b7ef5f5919166aad1f084"
	     "github.com/tidwall/gjson eee0b6226f0d1db2675a176fdfaa8419bcad4ca8"
	     "github.com/tidwall/pretty 1166b9ac2b65e46a43d8618d30d1554f4652d49b"
	     "github.com/tidwall/match 33827db735fff6510490d69a8622612558a557ed"
	     "github.com/streadway/amqp 14f78b41ce6da3d698c2ef2cc8c0ea7ce9e26688"
	     "github.com/skyrings/skyring-common d1c0bb1cbd5ed8438be1385c85c4f494608cde1e"
	     "github.com/segmentio/go-prompt f0d19b6901ade831d5a3204edc0d6a7d6457fbb2"
	     "github.com/rs/cors 9a47f48565a795472d43519dd49aac781f3034fb"
	     "github.com/rjeczalik/notify 69d839f37b13a8cb7a78366f7633a4071cb43be7"
	     "github.com/rcrowley/go-metrics 3113b8401b8a98917cde58f8bbd42a1b1c03b1fd"
	     "github.com/prometheus/client_golang 505eaef017263e299324067d40ca2c48f6a2cf50"
	     "github.com/prometheus/procfs 55ae3d9d557340b5bc24cd8aa5f6fa2c2ab31352"
	     "github.com/prometheus/common 5df5c82edb7502fd6cbe093223a19b6e1231494f"
	     "github.com/prometheus/client_model fd36f4220a901265f90734c3183c5f0c91daa0b8"
	     "github.com/pkg/profile f6fe06335df110bcf1ed6d4e852b760bfc15beee"
	     "github.com/pkg/errors ba968bfe8b2f7e042a574c888954fccecfa385b4"
	     "github.com/pierrec/lz4 315a67e90e415bcdaff33057da191569bf4d8479"
	     "github.com/nsqio/go-nsq eee57a3ac4174c55924125bb15eeeda8cffb6e6f"
	     "github.com/nats-io/nats 70fe06cee50d4b6f98248d9675fb55f2a3aa7228"
	     "github.com/nats-io/nuid 3024a71c3cbe30667286099921591e6fcc328230"
	     "github.com/nats-io/nkeys 1546a3320a8f195a5b5c84aef8309377c2e411d5"
	     "github.com/nats-io/go-nats 70fe06cee50d4b6f98248d9675fb55f2a3aa7228"
	     "github.com/nats-io/go-nats-streaming 4366d43a0648b4997ed32080f937e8702ab86c48"
	     "github.com/Azure/azure-sdk-for-go d659f2a91175cac99aa5627d09b83026eacc978d"
	     "github.com/Azure/go-autorest 3b1641ed03046f2ee28d73f7a51e5b884d55b92a"
	     "github.com/DataDog/zstd c7161f8c63c045cbc7ca051dcc969dd0e4054de2"
	     "github.com/mailru/easyjson 1ea4449da9834f4d333f1cc461c374aea217d249"
	     "github.com/gorilla/mux a7962380ca08b5a188038c69871b8d3fbdf31e89"
	     "github.com/coredns/coredns 8dcc7fccd74454134b33c8bc9f780ed6d7f076cf"
	     "github.com/matttproud/golang_protobuf_extensions c182affec369e30f25d3eb8cd8a478dee585ae7d"
	     "github.com/eapache/go-resiliency 842e16ec2c98ef0c59eebfe60d2d3500a793ba19"
	     "github.com/minio/minio-go 5325257a208fc630aaaac31bc00789acbc998c14"
	     "github.com/alecthomas/participle 98cb121381c371cf1542c7ae145e485d703aec0b"
	     "github.com/aliyun/aliyun-oss-go-sdk 86c17b95fcd5db33628a61e492fb4a1a937d5906"
	     "github.com/bcicen/jstream 16c1f8af81c2a9967b30d365a29472126274f998"
	     "github.com/beorn7/perks 3a771d992973f24aa725d07868b467d1ddfceafb"
	     "github.com/cheggaaa/pb f907f6f5dd81f77c2bbc1cde92e4c5a04720cb11"
	     "github.com/gogo/protobuf 382325bbbb4d1c850eec1f3ec92a1a16f502d68b"
	     "github.com/davecgh/go-spew d8f796af33cc11cb798c1aaeb27a4ebc5099927d"
	     "github.com/inconshreveable/go-update 8152e7eb6ccf8679a64582a66b78519688d156ad"
	     "github.com/howeyc/gopass bf9dde6d0d2c004a008c27aaee91170c786f6db8"
	     "github.com/mitchellh/go-homedir af06845cf3004701891bf4fdb884bfe4920b3727"
	     "github.com/klauspost/pgzip 083b1c3f84dd6486588802e5ce295de3a7f41a8b"
	     "github.com/marstr/guid 8bd9a64bf37eb297b492a4101fb28e80ac0b290f"
	     "github.com/coreos/etcd d57e8b8d97adfc4a6c224fe116714bf1a1f3beb9"
	     "github.com/dgrijalva/jwt-go 06ea1031745cb8b3dab3f6a236daf2b0aa468b7e"
	     "github.com/gorilla/rpc bffcfa752ad4e523cc8f720afeb5b985ed41ae16"
	     "github.com/djherbis/atime 8e47e0e01d08df8b9f840d74299c8ab70a024a30"
	     "github.com/dustin/go-humanize 9f541cc9db5d55bce703bd99987c9d5cb8eea45e"
	     "github.com/eapache/go-xerial-snappy 776d5712da21bc4762676d614db1d8a64f4238b0"
	     "github.com/eapache/queue 093482f3f8ce946c05bcba64badd2c82369e084d"
	     "github.com/golang/protobuf d3c38a4eb4970272b87a425ae00ccc4548e2f9bb"
	     "github.com/fatih/structs 4966fc68f5b7593aafa6cbbba2d65ec6e1416047"
	     "github.com/minio/parquet-go 9d767baf16793cc4b7fd55d642474c36c077ef77"
	     "gopkg.in/ini.v1 c85607071cf08ca1adaf48319cd1aa322e81d8c1 github.com/go-ini/ini"
	     "google.golang.org/grpc 3507fb8e1a5ad030303c106fef3a47c9fdad16ad github.com/grpc/grpc-go"
	     "google.golang.org/genproto 64821d5d210748c883cd2b809589555ae4654203 github.com/google/go-genproto"
	     "go.opencensus.io 43463a80402d8447b7fce0d2c58edf1687ff0b58 github.com/census-instrumentation/opencensus-go"
	     "git.apache.org/thrift.git c9b1e29bc9e0702d7441383358d565e1e76ccea7 github.com/apache/thrift"
	     "github.com/elazarl/go-bindata-assetfs 30f82fa23fd844bd5bb1e5f216db87fd77b5eb43"
	     "github.com/eclipse/paho.mqtt.golang 20337d8c394721c308cc6ec096990ee451a7cd7f"
	     "github.com/klauspost/compress 30be6041bed523c18e269a700ebd9c2ea9328574"
	     "github.com/hashicorp/vault 36aa8c8dd1936e10ebd7a4c1d412ae0e6f7900bd"
	     "github.com/fatih/color 5b77d2a35fb0ede96d138fc9a99f5c9b6aef11b4"
	     "github.com/miekg/dns 73601d4aed9d844322611759d7f3619110b7c88e"
	     "github.com/klauspost/reedsolomon a9588190c00b0ccd742218388f6ff68bbad83e5c"
	     "github.com/gomodule/redigo 9c11da706d9b7902c6da69c592f75637793fe121"
	     "github.com/go-sql-driver/mysql 72cd26f257d44c1114970e19afddcd812016007e"
	     "github.com/gorilla/handlers 7e0847f9db758cdebd26c149d0ae9d5d0b9c98ce"
	     "github.com/mattn/go-isatty c2a7a6ca930a4cd0bc33a3f298eb71960732a3a7"
	     "github.com/satori/go.uuid f58768cc1a7a7e77a3bd49e98cdd21419399b6a3"
	     "github.com/golang/snappy 2a8bb927dd31d8daada140a5d09578521ce5c36a"
	     "github.com/klauspost/cpuid e7e905edc00ea8827e58662220139109efea09db"
	     "contrib.go.opencensus.io/exporter/ocagent 902c0ccba68df93f7fefbe7e7c6f16be33108b40 github.com/census-ecosystem/opencensus-go-exporter-ocagent"
	     "github.com/lib/pq 4ded0e9383f75c197b3a2aaa6d590ac52df6fd79"
	     "github.com/mattn/go-runewidth 3ee7d812e62a0804a7d0a324e0249ca2db3476d3"
	     "github.com/census-instrumentation/opencensus-proto a105b96453fe85139acc07b68de48f2cbdd71249"
	     "github.com/minio/cli 8683fa7fef37cc8cb092f47bdb6b403e0049f9ee"
	     "github.com/minio/mc a1355e50e2e8984d645cc7745230c42b27396341"
	     "google.golang.org/api bce707a4d0ea3488942724b3bcc1c8338f38f991 github.com/googleapis/google-api-go-client"
	     "github.com/grpc-ecosystem/grpc-gateway 20f268a412e5b342ebfb1a0eef7c3b7bd6c260ea"
	     "github.com/mattn/go-colorable 3a70a971f94a22f2fa562ffcc7a0eb45f5daf045"
	     "github.com/minio/blazer 2081f5bf046503f576d8712253724fbf2950fffe"
	     "github.com/minio/highwayhash 02ca4b43caa3297fbb615700d8800acc7933be98"
	     "github.com/minio/lsync v1.0.1"
	     "github.com/minio/sha256-simd 05b4dd3047e5d6e86cb4e0477164b850cd896261"
	     "github.com/minio/sio 035b4ef8c449ba2ba21ec143c91964e76a1fb68c"
	     "golang.org/x/sync e225da77a7e68af35c70ccbf71af2b83e6acac3c github.com/golang/sync"
	     "golang.org/x/oauth2 9f3314589c9a9136388751d9adae6b0ed400978a github.com/golang/oauth2"
	     "cloud.google.com/go 458e1f376a2b44413160b5d301183b65debaa3f6 github.com/googleapis/google-cloud-go"
	     "github.com/googleapis/gax-go beaecbbdd8af86aa3acf14180d53828ce69400b2"
	     "github.com/hashicorp/golang-lru 7087cb70de9f7a8bc0a10c375cb0d2280a8edf9c"
	     "github.com/json-iterator/go 0ff49de124c6f76f8494e194af75bde0f1a49a29"
	     "github.com/colinmarc/hdfs/v2 fd1e410ff7bf76b870f625dc0aa3eb4e44f5bc50 github.com/colinmarc/hdfs"
	     "github.com/hashicorp/go-uuid 4f571afc59f3043a65f8fe6bf46d887b10a01d43"
	     "github.com/jcmturner/gofork dc7c13fece037a4a36e2b3c69db4991498d30692"
	     "github.com/modern-go/concurrent bacd9c7ef1dd9b15be4a9909b8ac7a4e313eec94"
	     "github.com/modern-go/reflect2 94122c33edd36123c84d5368cfb2b69df93a0ec8"
	     "gopkg.in/jcmturner/aescts.v1 f6abebb3171c4c1b1fea279cb7c7325020a26290 github.com/jcmturner/aescts"
	     "gopkg.in/jcmturner/dnsutils.v1 13eeb8d49ffb74d7a75784c35e4d900607a3943c github.com/jcmturner/dnsutils"
	     "github.com/klauspost/readahead v1.3.0"
	     "github.com/kurin/blazer v0.5.3"
	     "github.com/minio/dsync/v2 fedfb5c974fa2ab238e45a6e6b19d38774e0326f github.com/minio/dsync"
	     "github.com/ncw/directio v1.0.5"
	     "github.com/nats-io/stan.go v0.4.5"
	     "github.com/nats-io/nats.go v1.8.0"
	     "github.com/minio/minio-go v6.0.29"
	     "github.com/minio/hdfs/v3 v3.0.1 github.com/minio/hdfs"
	     "github.com/minio/gokrb5/v7 v7.2.5 github.com/minio/gokrb5"
	     "github.com/minio/minio-go/v6 v6.0.29 github.com/minio/minio-go"
	     "gopkg.in/jcmturner/goidentity.v3 v5.0.0 github.com/jcmturner/goidentity"
	     "gopkg.in/jcmturner/rpc.v1  99a8ce2fbf8b8087b6ed12a37c61b10f04070043 github.com/jcmturner/rpc"
	     "gopkg.in/jcmturner/goidentity.v2 v2.0.0 github.com/jcmturner/goidentity"
	     "gopkg.in/jcmturner/goidentity.v3 v3.0.0 github.com/jcmturner/goidentity"
	     "github.com/kurin/blazer cf2f27cc0be3dac3c1a94c3c8b76834ce741439e"
	     "gopkg.in/ldap.v3 v3.0.3 github.com/go-ldap/ldap"
	     "gopkg.in/asn1-ber.v1 f715ec2f112d1e4195b827ad68cf44017a3ef2b1 github.com/go-asn1-ber/asn1-ber"
)

inherit user golang-build golang-vcs-snapshot

EGO_PN="github.com/minio/minio"
MY_PV="$(ver_cut 1-3)T$(ver_cut 4-7)Z"
MY_PV=${MY_PV//./-}
EGIT_COMMIT="3e3fbdf8e6e5e889232eb7afc0b27ac054adfda0"
ARCHIVE_URI="https://${EGO_PN}/archive/RELEASE.${MY_PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

KEYWORDS="~amd64 ~amd64-linux"

DESCRIPTION="An Amazon S3 compatible object storage server"
HOMEPAGE="https://github.com/minio/minio"
SRC_URI="${ARCHIVE_URI}"
LICENSE="Apache-2.0 BSD BSD-2 MIT MPL-2.0"
SLOT="0"

RESTRICT="test"

RDEPEND=">=dev-lang/go-1.13"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/${PN} ${PN}
}

src_prepare() {
	default

	pushd src/${EGO_PN} || die

	rm go.mod || die

	sed -i -e "s/time.Now().UTC().Format(time.RFC3339)/\"${MY_PV}\"/"\
		-e "s/-s //"\
		-e "/time/d"\
		-e "s/+ commitID()/+ \"${EGIT_COMMIT}\"/"\
		buildscripts/gen-ldflags.go || die

	popd || die
}

src_compile() {
	unset XDG_CACHE_HOME

	pushd src/${EGO_PN} || die
	MINIO_RELEASE="${MY_PV}"
	go run buildscripts/gen-ldflags.go
	GOS=Linux GOPATH="${S}" GOCACHE="${T}"/go-cache go build --ldflags "$(go run buildscripts/gen-ldflags.go)" -o ${PN} || die

	popd || die
}

src_install() {
	pushd src/${EGO_PN} || die
	dodoc -r README.md CONTRIBUTING.md MAINTAINERS.md docs
	dobin minio
	popd  || die
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	keepdir /var/{lib,log}/${PN}
	fowners ${PN}:${PN} /var/{lib,log}/${PN}
}
