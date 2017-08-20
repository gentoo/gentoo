# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EGO_PN="github.com/cesanta/docker_auth"

EGO_VENDOR=(
	"github.com/dchest/uniuri 8902c56451e9b58ff940bbe5fec35d5f9c04584a"
	"github.com/deckarep/golang-set 3a36ffa8b5bf7cd329c8834c6b743d6930dad12f"
	"github.com/docker/distribution f86db6b22663a27ba4d278220b7e34be528b1e79"
	"github.com/docker/libtrust aabc10ec26b754e797f9028f4589c5b7bd90dc20"
	"github.com/facebookgo/httpdown a3b1354551a26449fbe05f5d855937f6e7acbd71"
	"github.com/facebookgo/clock 600d898af40aa09a7a93ecb9265d87b0504b6f03"
	"github.com/facebookgo/stats 1b76add642e42c6ffba7211ad7b3939ce654526e"
	"github.com/go-ldap/ldap 37f35d7ffc6b8219cc62f5e182e258d143be670b"
	"github.com/cesanta/glog 22eb27a0ae192b290b25537b8e876556fc25129c"
	"github.com/syndtr/goleveldb 8c81ea47d4c41a385645e133e15510fc6a2a74b4"
	"github.com/golang/snappy 553a641470496b2327abcac10b36396bd98e45c9"
	"gopkg.in/asn1-ber.v1 b144e4fe15d4968eb8d6e33d70761727d124814e github.com/go-asn1-ber/asn1-ber"
	"gopkg.in/fsnotify.v1 4da3e2cfbabc9f751898f250b49f2439785783a1 github.com/fsnotify/fsnotify"
	"gopkg.in/mgo.v2 3f83fa5005286a7fe593b055f0d7771a7dce4655 github.com/go-mgo/mgo"
	"gopkg.in/yaml.v2 3b4ad1db5b2a649883ff3782f5f9f6fb52be71af github.com/go-yaml/yaml"
	"golang.org/x/crypto 5a033cc77e57eca05bdb50522851d29e03569cbe github.com/golang/crypto"
	"golang.org/x/sys 9ccfe848b9db8435a24c424abbc07a921adf1df5 github.com/golang/sys"
	)

inherit user golang-build golang-vcs-snapshot
EGIT_COMMIT="d76a69c31cdef1ea1c21b0c675aaeaef6d87594f"
SHORT_COMMIT=${EGIT_COMMIT:0:7}
SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"
KEYWORDS="~amd64"

DESCRIPTION="Docker Registry 2 authentication server"
HOMEPAGE="https://github.com/cesanta/docker_auth"

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
	pushd src/${EGO_PN}
	eapply "${FILESDIR}/${PN}-ldap-group-support.patch"
	cp "${FILESDIR}/version.go" auth_server/version.go || die
	sed -i -e "s/{version}/${PV}/" -e "s/{build_id}/${SHORT_COMMIT}/" auth_server/version.go || die
	popd || die
}

src_compile() {
	pushd src/${EGO_PN}/auth_server || die
	GOPATH="${WORKDIR}/${P}" go build -o "bin/auth_server" || die
	popd || die
}

src_install() {
	pushd src/${EGO_PN} || die
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
