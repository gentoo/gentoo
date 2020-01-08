# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EGO_PN="github.com/cesanta/docker_auth"

EGO_VENDOR=(
	"github.com/dchest/uniuri 8902c56451e9b58ff940bbe5fec35d5f9c04584a"
	"github.com/deckarep/golang-set fc8930a5e645572ee00bf66358ed3414f3c13b90"
	"github.com/docker/distribution 0700fa570d7bcc1b3e46ee127c4489fd25f4daa3"
	"github.com/docker/libtrust aabc10ec26b754e797f9028f4589c5b7bd90dc20"
	"github.com/facebookgo/httpdown a3b1354551a26449fbe05f5d855937f6e7acbd71"
	"github.com/facebookgo/clock 600d898af40aa09a7a93ecb9265d87b0504b6f03"
	"github.com/facebookgo/stats 1b76add642e42c6ffba7211ad7b3939ce654526e"
	"github.com/go-ldap/ldap 13cedcf58a1ea124045dea529a66c849d3444c8e"
	"github.com/cesanta/glog 22eb27a0ae192b290b25537b8e876556fc25129c"
	"github.com/schwarmco/go-cartesian-product c2c0aca869a6cbf51e017ce148b949d9dee09bc3"
	"github.com/syndtr/goleveldb 3c5717caf1475fd25964109a0fc640bd150fce43"
	"github.com/golang/snappy 553a641470496b2327abcac10b36396bd98e45c9"
	"gopkg.in/asn1-ber.v1 4e86f4367175e39f69d9358a5f17b4dda270378d github.com/go-asn1-ber/asn1-ber"
	"gopkg.in/fsnotify.v1 629574ca2a5df945712d3079857300b5e4da0236 github.com/fsnotify/fsnotify"
	"gopkg.in/mgo.v2 3f83fa5005286a7fe593b055f0d7771a7dce4655 github.com/go-mgo/mgo"
	"gopkg.in/yaml.v2 a3f3340b5840cee44f372bddb5880fcbc419b46a github.com/go-yaml/yaml"
	"golang.org/x/crypto e1a4589e7d3ea14a3352255d04b6f1a418845e5e github.com/golang/crypto"
	"golang.org/x/sys 493114f68206f85e7e333beccfabc11e98cba8dd github.com/golang/sys"
	"golang.org/x/net 859d1a86bb617c0c20d154590c3c5d3fcb670b07 github.com/golang/net"
	"google.golang.org/api 39c3dd417c5a443607650f18e829ad308da08dd2 github.com/google/google-api-go-client"
	"google.golang.org/grpc 35170916ff58e89ae03f52e778228e18207e0e02 github.com/grpc/grpc-go"
	"github.com/golang/protobuf 11b8df160996e00fd4b55cbaafb3d84ec6d50fa8"
	"golang.org/x/oauth2 13449ad91cb26cb47661c1b080790392170385fd github.com/golang/oauth2"
	"cloud.google.com/go 20d4028b8a750c2aca76bf9fefa8ed2d0109b573 github.com/GoogleCloudPlatform/gcloud-golang"
	"golang.org/x/text ab5ac5f9a8deb4855a60fab02bc61a4ec770bd49 github.com/golang/text"
	"github.com/googleapis/gax-go 8c160ca1523d8eea3932fbaa494c8964b7724aa8"
	"google.golang.org/genproto 595979c8a7bf586b2d293fb42246bf91a0b893d9 github.com/google/go-genproto"
	)

inherit user golang-build golang-vcs-snapshot
EGIT_COMMIT="b89dec9a4f0098fb0f71d9b94e44d1710c1fe5cf"
SHORT_COMMIT=${EGIT_COMMIT:0:7}
SRC_URI="https://${EGO_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"
KEYWORDS="~amd64"

DESCRIPTION="Docker Registry 2 authentication server"
HOMEPAGE="https://github.com/cesanta/docker_auth"

LICENSE="Apache-2.0 BSD BSD-2 LGPL-3 MIT ZLIB"
SLOT="0"
IUSE=""

DEPEND="dev-go/go-bindata"

RESTRICT="test"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /dev/null ${PN}
}

src_prepare() {
	default
	pushd src/${EGO_PN}
	cp "${FILESDIR}/version.go" auth_server/version.go || die
	sed -i -e "s/{version}/${PV}/" -e "s/{build_id}/${SHORT_COMMIT}/" auth_server/version.go || die
	sed -i -e "/.*gen_version.py*/d" auth_server/main.go || die
	popd || die
}

src_compile() {
	pushd src/${EGO_PN}/auth_server || die
	GOPATH="${WORKDIR}/${P}" emake generate
	GOPATH="${WORKDIR}/${P}" go build -v -o "bin/auth_server" || die
	popd || die
}

src_install() {
	pushd src/${EGO_PN} || die
	dodoc README.md docs/*
	insinto /usr/share/${PF}
	doins -r examples
	insinto /etc/docker_auth/
	newins examples/reference.yml config.yml.example
	dobin auth_server/bin/auth_server
	popd || die
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}.logrotated ${PN}
	keepdir /var/log/docker_auth
	fowners ${PN}:${PN} /var/log/docker_auth
}
