# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=( "github.com/docopt/docopt-go 784ddc588536785e7299f7272f39101f7faccc3f"
	"github.com/gavv/monotime 47d58efa69556a936a3c15eb2ed42706d968ab01"
	"github.com/go-ini/ini 20b96f641a5ea98f2f8619ff4f3e061cff4833bd"
	"github.com/gogo/protobuf 100ba4e885062801d56799d78530b73b178a78f3"
	"github.com/kardianos/osext ae77be60afb1dcacde03767a8c37337fad28ac14"
	"github.com/mipearson/rfw 6f0a6f3266ba1058df9ef0c94cda1cecd2e62852"
	"github.com/projectcalico/libcalico-go fc4a3648215b9beda5d08e26d76e91f12fb45079"
	"github.com/coreos/etcd d267ca9c184e953554257d0acdd1dc9c47d38229"
	"github.com/kelseyhightower/envconfig f611eb38b3875cc3bd991ca91c51d06446afa14c"
	"github.com/projectcalico/go-yaml-wrapper 598e54215bee41a19677faa4f0c32acd2a87eb56"
	"github.com/projectcalico/typha 71413e6c4e8f903f899429329cf3e38e17633ba5"
	"github.com/coreos/pkg fa29b1d70f0beaddd4c7021607cc3c3be8ce94b8"
	"github.com/projectcalico/go-json 6219dc7339ba20ee4c57df0a8baac62317d19cb1"
	"github.com/projectcalico/go-yaml 955bc3e451ef0c9df8b9113bf2e341139cdafab2"
	"github.com/prometheus/client_golang c5b7fccd204277076155f10851dad72b76a49317"
	"github.com/beorn7/perks 4c0e84591b9aa9e6dcfdf3e020114cd81f89d5f9"
	"github.com/coreos/go-systemd 2688e91251d9d8e404e86dd8f096e23b2f086958"
	"github.com/golang/protobuf 8616e8ee5e20a1704615e6c8d7afcdac06087a67"
	"github.com/prometheus/client_model 6f3806018612930941127f2a7c6c453ba2c527d2"
	"github.com/prometheus/common 61f87aac8082fa8c3c5655c7608d7478d46ac2ad"
	"github.com/matttproud/golang_protobuf_extensions c12348ce28de40eed0136aa2b644d0ee0650e56c"
	"github.com/prometheus/procfs e645f4e5aaa8506fc71d6edbc5c4ff02c04c46f2"
	"github.com/satori/go.uuid 879c5887cd475cd7864858769793b2ceb0d44feb"
	"github.com/sirupsen/logrus ba1b36c82c5e05c4f912a88eab0dcd91a171688f"
	"github.com/ugorji/go ded73eae5db7e7a0ef6f55aace87a2873c5d2b74"
	"github.com/vishvananda/netlink f5a6f697a596c788d474984a38a0ac4ba0719e93"
	"github.com/vishvananda/netns 86bef332bfc3b59b7624a600bd53009ce91a9829"
	"github.com/golang/glog 44145f04b68cf362d9c4df2182967c2275eaefed"
	"golang.org/x/net 3da985ce5951d99de868be4385f21ea6c2b22f24 github.com/golang/net"
	"golang.org/x/sys 43e60d72a8e2bd92ee98319ba9a384a0e9837c08 github.com/golang/sys"
	"gopkg.in/go-playground/validator.v8 5f1438d3fca68893a817e4a66806cea46a9e4ebf github.com/go-playground/validator"
	"gopkg.in/tchap/go-patricia.v2 666120de432aea38ab06bd5c818f04f4129882c9 github.com/tchap/go-patricia"
	"k8s.io/apimachinery b317fa7ec8e0e7d1f77ac63bf8c3ec7b29a2a215 github.com/kubernetes/apimachinery"
	"k8s.io/client-go 4a3ab2f5be5177366f8206fd79ce55ca80e417fa github.com/kubernetes/client-go")

inherit golang-vcs-snapshot systemd user

FELIX_COMMIT="53553b4f7ff80d193e8550ee3b31704da5349d42"

KEYWORDS="~amd64"
DESCRIPTION="Calico's per-host agent, responsible for programming routes and security policy"
EGO_PN="github.com/projectcalico/felix"
HOMEPAGE="https://github.com/projectcalico/felix"
SRC_URI="https://${EGO_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RESTRICT="test"

DEPEND=">=dev-libs/protobuf-3
	dev-go/gogo-protobuf"

src_compile() {
	pushd "src/${EGO_PN}" || die
	protoc --gogofaster_out=. proto/*.proto || die
	GOPATH="${WORKDIR}/${P}" CGO_ENABLED=0 go build -v -o bin/calico-felix -ldflags \
		"-X github.com/projectcalico/felix/buildinfo.GitVersion=${PV} \
		-X github.com/projectcalico/felix/buildinfo.BuildDate=$(date -u +'%FT%T%z') \
		-X github.com/projectcalico/felix/buildinfo.GitRevision=${FELIX_COMMIT}" "github.com/projectcalico/felix" || die
	popd || die
}

src_install() {
	pushd "src/${EGO_PN}" || die
	dobin "bin/calico-${PN}"
	dodoc README.md
	insinto /etc/logrotate.d
	doins debian/calico-felix.logrotate
	insinto /etc/felix
	doins etc/felix.cfg.example
	newinitd "${FILESDIR}"/felix.initd felix
	newconfd "${FILESDIR}"/felix.confd felix
}
