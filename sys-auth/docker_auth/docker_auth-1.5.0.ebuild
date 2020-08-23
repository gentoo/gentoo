# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module
EGIT_COMMIT=df57ccaa8701a527954bd2a813fedec1b7c86af0
SHORT_COMMIT=${EGIT_COMMIT:0:7}

DESCRIPTION="Docker Registry 2 authentication server"
HOMEPAGE="https://github.com/cesanta/docker_auth"

EGO_SUM=(
	"cloud.google.com/go v0.26.0/go.mod"
	"cloud.google.com/go v0.34.0/go.mod"
	"cloud.google.com/go v0.38.0/go.mod"
	"cloud.google.com/go v0.44.1/go.mod"
	"cloud.google.com/go v0.44.3"
	"cloud.google.com/go v0.44.3/go.mod"
	"cloud.google.com/go/datastore v1.0.0/go.mod"
	"github.com/BurntSushi/toml v0.3.1/go.mod"
	"github.com/BurntSushi/xgb v0.0.0-20160522181843-27f122750802/go.mod"
	"github.com/a-urth/go-bindata v0.0.0-20180209162145-df38da164efc"
	"github.com/a-urth/go-bindata v0.0.0-20180209162145-df38da164efc/go.mod"
	"github.com/cesanta/glog v0.0.0-20150527111657-22eb27a0ae19"
	"github.com/cesanta/glog v0.0.0-20150527111657-22eb27a0ae19/go.mod"
	"github.com/client9/misspell v0.3.4/go.mod"
	"github.com/davecgh/go-spew v1.1.1/go.mod"
	"github.com/dchest/uniuri v0.0.0-20160212164326-8902c56451e9"
	"github.com/dchest/uniuri v0.0.0-20160212164326-8902c56451e9/go.mod"
	"github.com/deckarep/golang-set v1.7.1"
	"github.com/deckarep/golang-set v1.7.1/go.mod"
	"github.com/docker/distribution v2.7.1+incompatible"
	"github.com/docker/distribution v2.7.1+incompatible/go.mod"
	"github.com/docker/libtrust v0.0.0-20160708172513-aabc10ec26b7"
	"github.com/docker/libtrust v0.0.0-20160708172513-aabc10ec26b7/go.mod"
	"github.com/facebookgo/clock v0.0.0-20150410010913-600d898af40a"
	"github.com/facebookgo/clock v0.0.0-20150410010913-600d898af40a/go.mod"
	"github.com/facebookgo/httpdown v0.0.0-20180706035922-5979d39b15c2"
	"github.com/facebookgo/httpdown v0.0.0-20180706035922-5979d39b15c2/go.mod"
	"github.com/facebookgo/stats v0.0.0-20151006221625-1b76add642e4"
	"github.com/facebookgo/stats v0.0.0-20151006221625-1b76add642e4/go.mod"
	"github.com/fsnotify/fsnotify v1.4.7/go.mod"
	"github.com/go-ldap/ldap v3.0.3+incompatible"
	"github.com/go-ldap/ldap v3.0.3+incompatible/go.mod"
	"github.com/golang/glog v0.0.0-20160126235308-23def4e6c14b/go.mod"
	"github.com/golang/mock v1.1.1/go.mod"
	"github.com/golang/mock v1.2.0/go.mod"
	"github.com/golang/mock v1.3.1/go.mod"
	"github.com/golang/protobuf v1.2.0/go.mod"
	"github.com/golang/protobuf v1.3.1/go.mod"
	"github.com/golang/protobuf v1.3.2"
	"github.com/golang/protobuf v1.3.2/go.mod"
	"github.com/golang/snappy v0.0.0-20180518054509-2e65f85255db"
	"github.com/golang/snappy v0.0.0-20180518054509-2e65f85255db/go.mod"
	"github.com/google/btree v0.0.0-20180813153112-4030bb1f1f0c/go.mod"
	"github.com/google/btree v1.0.0/go.mod"
	"github.com/google/go-cmp v0.2.0/go.mod"
	"github.com/google/go-cmp v0.3.0/go.mod"
	"github.com/google/martian v2.1.0+incompatible/go.mod"
	"github.com/google/pprof v0.0.0-20181206194817-3ea8567a2e57/go.mod"
	"github.com/google/pprof v0.0.0-20190515194954-54271f7e092f/go.mod"
	"github.com/googleapis/gax-go/v2 v2.0.4/go.mod"
	"github.com/googleapis/gax-go/v2 v2.0.5"
	"github.com/googleapis/gax-go/v2 v2.0.5/go.mod"
	"github.com/gorilla/mux v1.7.3"
	"github.com/gorilla/mux v1.7.3/go.mod"
	"github.com/hashicorp/golang-lru v0.5.0/go.mod"
	"github.com/hashicorp/golang-lru v0.5.1"
	"github.com/hashicorp/golang-lru v0.5.1/go.mod"
	"github.com/hpcloud/tail v1.0.0/go.mod"
	"github.com/jstemmer/go-junit-report v0.0.0-20190106144839-af01ea7f8024/go.mod"
	"github.com/konsorten/go-windows-terminal-sequences v1.0.1/go.mod"
	"github.com/onsi/ginkgo v1.6.0/go.mod"
	"github.com/onsi/ginkgo v1.7.0/go.mod"
	"github.com/onsi/gomega v1.4.3/go.mod"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/schwarmco/go-cartesian-product v0.0.0-20180515110546-d5ee747a6dc9"
	"github.com/schwarmco/go-cartesian-product v0.0.0-20180515110546-d5ee747a6dc9/go.mod"
	"github.com/sirupsen/logrus v1.4.2"
	"github.com/sirupsen/logrus v1.4.2/go.mod"
	"github.com/stretchr/objx v0.1.1/go.mod"
	"github.com/stretchr/testify v1.2.2/go.mod"
	"github.com/syndtr/goleveldb v1.0.0"
	"github.com/syndtr/goleveldb v1.0.0/go.mod"
	"go.opencensus.io v0.21.0/go.mod"
	"go.opencensus.io v0.22.0"
	"go.opencensus.io v0.22.0/go.mod"
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
	"golang.org/x/crypto v0.0.0-20190605123033-f99c8df09eb5/go.mod"
	"golang.org/x/crypto v0.0.0-20190820162420-60c769a6c586"
	"golang.org/x/crypto v0.0.0-20190820162420-60c769a6c586/go.mod"
	"golang.org/x/exp v0.0.0-20190121172915-509febef88a4/go.mod"
	"golang.org/x/exp v0.0.0-20190510132918-efd6b22b2522/go.mod"
	"golang.org/x/image v0.0.0-20190227222117-0694c2d4d067/go.mod"
	"golang.org/x/lint v0.0.0-20181026193005-c67002cb31c3/go.mod"
	"golang.org/x/lint v0.0.0-20190227174305-5b3e6a55c961/go.mod"
	"golang.org/x/lint v0.0.0-20190301231843-5614ed5bae6f/go.mod"
	"golang.org/x/lint v0.0.0-20190313153728-d0100b6bd8b3/go.mod"
	"golang.org/x/lint v0.0.0-20190409202823-959b441ac422/go.mod"
	"golang.org/x/mobile v0.0.0-20190312151609-d3739f865fa6/go.mod"
	"golang.org/x/net v0.0.0-20180724234803-3673e40ba225/go.mod"
	"golang.org/x/net v0.0.0-20180826012351-8a410e7b638d/go.mod"
	"golang.org/x/net v0.0.0-20180906233101-161cd47e91fd/go.mod"
	"golang.org/x/net v0.0.0-20190108225652-1e06a53dbb7e/go.mod"
	"golang.org/x/net v0.0.0-20190213061140-3a22650c66bd/go.mod"
	"golang.org/x/net v0.0.0-20190311183353-d8887717615a/go.mod"
	"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod"
	"golang.org/x/net v0.0.0-20190501004415-9ce7a6920f09/go.mod"
	"golang.org/x/net v0.0.0-20190503192946-f4e77d36d62c/go.mod"
	"golang.org/x/net v0.0.0-20190603091049-60506f45cf65/go.mod"
	"golang.org/x/net v0.0.0-20190620200207-3b0461eec859/go.mod"
	"golang.org/x/net v0.0.0-20190813141303-74dc4d7220e7"
	"golang.org/x/net v0.0.0-20190813141303-74dc4d7220e7/go.mod"
	"golang.org/x/oauth2 v0.0.0-20180821212333-d2e6202438be/go.mod"
	"golang.org/x/oauth2 v0.0.0-20190226205417-e64efc72b421/go.mod"
	"golang.org/x/oauth2 v0.0.0-20190604053449-0f29369cfe45"
	"golang.org/x/oauth2 v0.0.0-20190604053449-0f29369cfe45/go.mod"
	"golang.org/x/sync v0.0.0-20180314180146-1d60e4601c6f/go.mod"
	"golang.org/x/sync v0.0.0-20181108010431-42b317875d0f/go.mod"
	"golang.org/x/sync v0.0.0-20181221193216-37e7f081c4d4/go.mod"
	"golang.org/x/sync v0.0.0-20190227155943-e225da77a7e6/go.mod"
	"golang.org/x/sync v0.0.0-20190423024810-112230192c58/go.mod"
	"golang.org/x/sys v0.0.0-20180830151530-49385e6e1522/go.mod"
	"golang.org/x/sys v0.0.0-20180909124046-d0be0721c37e/go.mod"
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
	"golang.org/x/sys v0.0.0-20190312061237-fead79001313/go.mod"
	"golang.org/x/sys v0.0.0-20190412213103-97732733099d/go.mod"
	"golang.org/x/sys v0.0.0-20190422165155-953cdadca894/go.mod"
	"golang.org/x/sys v0.0.0-20190502145724-3ef323f4f1fd/go.mod"
	"golang.org/x/sys v0.0.0-20190507160741-ecd444e8653b/go.mod"
	"golang.org/x/sys v0.0.0-20190606165138-5da285871e9c/go.mod"
	"golang.org/x/sys v0.0.0-20190624142023-c5567b49c5d0"
	"golang.org/x/sys v0.0.0-20190624142023-c5567b49c5d0/go.mod"
	"golang.org/x/text v0.3.0/go.mod"
	"golang.org/x/text v0.3.1-0.20180807135948-17ff2d5776d2/go.mod"
	"golang.org/x/text v0.3.2"
	"golang.org/x/text v0.3.2/go.mod"
	"golang.org/x/time v0.0.0-20181108054448-85acf8d2951c/go.mod"
	"golang.org/x/time v0.0.0-20190308202827-9d24e82272b4/go.mod"
	"golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod"
	"golang.org/x/tools v0.0.0-20190114222345-bf090417da8b/go.mod"
	"golang.org/x/tools v0.0.0-20190226205152-f727befe758c/go.mod"
	"golang.org/x/tools v0.0.0-20190311212946-11955173bddd/go.mod"
	"golang.org/x/tools v0.0.0-20190312151545-0bb0c0a6e846/go.mod"
	"golang.org/x/tools v0.0.0-20190312170243-e65039ee4138/go.mod"
	"golang.org/x/tools v0.0.0-20190425150028-36563e24a262/go.mod"
	"golang.org/x/tools v0.0.0-20190506145303-2d16b83fe98c/go.mod"
	"golang.org/x/tools v0.0.0-20190606124116-d0a3d012864b/go.mod"
	"golang.org/x/tools v0.0.0-20190628153133-6cdbf07be9d0/go.mod"
	"google.golang.org/api v0.4.0/go.mod"
	"google.golang.org/api v0.7.0/go.mod"
	"google.golang.org/api v0.8.0/go.mod"
	"google.golang.org/api v0.9.0"
	"google.golang.org/api v0.9.0/go.mod"
	"google.golang.org/appengine v1.1.0/go.mod"
	"google.golang.org/appengine v1.4.0/go.mod"
	"google.golang.org/appengine v1.5.0/go.mod"
	"google.golang.org/appengine v1.6.1/go.mod"
	"google.golang.org/genproto v0.0.0-20180817151627-c66870c02cf8/go.mod"
	"google.golang.org/genproto v0.0.0-20190307195333-5fe7a883aa19/go.mod"
	"google.golang.org/genproto v0.0.0-20190418145605-e7d98fc518a7/go.mod"
	"google.golang.org/genproto v0.0.0-20190425155659-357c62f0e4bb/go.mod"
	"google.golang.org/genproto v0.0.0-20190502173448-54afdca5d873/go.mod"
	"google.golang.org/genproto v0.0.0-20190801165951-fa694d86fc64"
	"google.golang.org/genproto v0.0.0-20190801165951-fa694d86fc64/go.mod"
	"google.golang.org/grpc v1.19.0/go.mod"
	"google.golang.org/grpc v1.20.1/go.mod"
	"google.golang.org/grpc v1.21.1"
	"google.golang.org/grpc v1.21.1/go.mod"
	"gopkg.in/asn1-ber.v1 v1.0.0-20181015200546-f715ec2f112d"
	"gopkg.in/asn1-ber.v1 v1.0.0-20181015200546-f715ec2f112d/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/fsnotify.v1 v1.4.7"
	"gopkg.in/fsnotify.v1 v1.4.7/go.mod"
	"gopkg.in/mgo.v2 v2.0.0-20190816093944-a6b53ec6cb22"
	"gopkg.in/mgo.v2 v2.0.0-20190816093944-a6b53ec6cb22/go.mod"
	"gopkg.in/tomb.v1 v1.0.0-20141024135613-dd632973f1e7/go.mod"
	"gopkg.in/yaml.v2 v2.2.1/go.mod"
	"gopkg.in/yaml.v2 v2.2.2"
	"gopkg.in/yaml.v2 v2.2.2/go.mod"
	"honnef.co/go/tools v0.0.0-20190102054323-c2f93a96b099/go.mod"
	"honnef.co/go/tools v0.0.0-20190106161140-3f1c8253044a/go.mod"
	"honnef.co/go/tools v0.0.0-20190418001031-e561f6794a2a/go.mod"
	"rsc.io/binaryregexp v0.2.0/go.mod"
	)
go-module_set_globals
SRC_URI="https://github.com/cesanta/docker_auth/archive/${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

LICENSE="Apache-2.0 BSD BSD-2 LGPL-3 MIT ZLIB"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

BDEPEND="dev-go/go-bindata"
COMMON_DEPEND="acct-group/docker_auth
	acct-user/docker_auth"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

RESTRICT+=" test"

src_prepare() {
	default
	cp "${FILESDIR}/version.go" auth_server/version.go || die
	sed -i \
		-e "s/{version}/${PV}/" \
		-e "s/{build_id}/${SHORT_COMMIT}/" \
		auth_server/version.go || die
	sed -i \
		-e "/.*gen_version.py*/d" \
		auth_server/main.go || die
}

src_compile() {
	pushd auth_server || die
	emake generate
	go build -v -o "bin/auth_server" || die
	popd || die
}

src_install() {
	dodoc README.md docs/*
	insinto /usr/share/${PF}
	doins -r examples
	insinto /etc/docker_auth/
	newins examples/reference.yml config.yml.example
	dobin auth_server/bin/auth_server
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}.logrotated ${PN}
	keepdir /var/log/docker_auth
	fowners ${PN}:${PN} /var/log/docker_auth
}
