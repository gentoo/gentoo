# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EGO_PN="github.com/cesanta/docker_auth/..."

EGO_VENDOR=(
	"github.com/dchest/uniuri 8902c56451e9b58ff940bbe5fec35d5f9c04584a"
	"github.com/deckarep/golang-set fc8930a5e645572ee00bf66358ed3414f3c13b90"
	"github.com/docker/distribution 08b06dc023674763e7b36d404cf0c7664cee1f5e"
	"github.com/docker/libtrust aabc10ec26b754e797f9028f4589c5b7bd90dc20"
	"github.com/facebookgo/httpdown a3b1354551a26449fbe05f5d855937f6e7acbd71"
	"github.com/facebookgo/clock 600d898af40aa09a7a93ecb9265d87b0504b6f03"
	"github.com/facebookgo/stats 1b76add642e42c6ffba7211ad7b3939ce654526e"
	"github.com/go-ldap/ldap 13cedcf58a1ea124045dea529a66c849d3444c8e"
	"github.com/golang/glog 23def4e6c14b4da8ac2ed8007337bc5eb5007998"
	"github.com/syndtr/goleveldb 6b4daa5362b502898ddf367c5c11deb9e7a5c727"
	"github.com/golang/snappy d9eb7a3d35ec988b8585d4a0068e462c27d28380"
	"gopkg.in/asn1-ber.v1 4e86f4367175e39f69d9358a5f17b4dda270378d github.com/go-asn1-ber/asn1-ber"
	"gopkg.in/fsnotify.v1 629574ca2a5df945712d3079857300b5e4da0236 github.com/fsnotify/fsnotify"
	"gopkg.in/mgo.v2 3f83fa5005286a7fe593b055f0d7771a7dce4655 github.com/go-mgo/mgo"
	"gopkg.in/yaml.v2 a5b47d31c556af34a302ce5d659e6fea44d90de0 github.com/go-yaml/yaml"
	"golang.org/x/crypto 728b753d0135da6801d45a38e6f43ff55779c5c2 github.com/golang/crypto"
	"golang.org/x/sys 99f16d856c9836c42d24e7ab64ea72916925fa97 github.com/golang/sys"
	)

inherit user golang-build golang-vcs-snapshot
EGIT_COMMIT="286369f8bf1d79c27c9f92f2b38d93511f4a7fe6"
SHORT_COMMIT=${EGIT_COMMIT:0:7}
SRC_URI="https://${EGO_PN%/*}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"
KEYWORDS="~amd64"

DESCRIPTION="Docker Registry 2 authentication server"
HOMEPAGE="http://github.com/cesanta/docker_auth"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RESTRICT="test"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /dev/null ${PN}
}

src_prepare() {
	default
	cp "${FILESDIR}/version.go" src/${EGO_PN%/*}/auth_server/version.go || die
	sed -i -e "s/{version}/${PV}/" -e "s/{build_id}/${SHORT_COMMIT}/" src/${EGO_PN%/*}/auth_server/version.go || die
}

src_compile() {
	pushd src/${EGO_PN%/*}/auth_server || die
	GOPATH="${WORKDIR}/${P}" go build -o "bin/auth_server" || die
	popd || die
}

src_install() {
	pushd src/${EGO_PN%/*} || die
	dodoc README.md docs/Backend_MongoDB.md
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
}
