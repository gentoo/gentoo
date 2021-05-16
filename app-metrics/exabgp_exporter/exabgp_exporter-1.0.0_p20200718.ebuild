# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module systemd

DESCRIPTION="Prometheus exporter for exabgp"
HOMEPAGE="https://github.com/lusis/exabgp_exporter"
EGIT_COMMIT="6fe8ef056a87881c8d7568cba83b3c18f7165d3a"

EGO_SUM=(
"github.com/alecthomas/template v0.0.0-20160405071501-a0175ee3bccc"
"github.com/alecthomas/template v0.0.0-20160405071501-a0175ee3bccc/go.mod"
"github.com/alecthomas/units v0.0.0-20151022065526-2efee857e7cf"
"github.com/alecthomas/units v0.0.0-20151022065526-2efee857e7cf/go.mod"
"github.com/beorn7/perks v0.0.0-20180321164747-3a771d992973"
"github.com/beorn7/perks v0.0.0-20180321164747-3a771d992973/go.mod"
"github.com/davecgh/go-spew v1.1.0"
"github.com/davecgh/go-spew v1.1.0/go.mod"
"github.com/davecgh/go-spew v1.1.1"
"github.com/davecgh/go-spew v1.1.1/go.mod"
"github.com/golang/protobuf v1.2.0"
"github.com/golang/protobuf v1.2.0/go.mod"
"github.com/konsorten/go-windows-terminal-sequences v1.0.1"
"github.com/konsorten/go-windows-terminal-sequences v1.0.1/go.mod"
"github.com/matttproud/golang_protobuf_extensions v1.0.1"
"github.com/matttproud/golang_protobuf_extensions v1.0.1/go.mod"
"github.com/pmezard/go-difflib v1.0.0"
"github.com/pmezard/go-difflib v1.0.0/go.mod"
"github.com/prometheus/client_golang v0.9.2"
"github.com/prometheus/client_golang v0.9.2/go.mod"
"github.com/prometheus/client_model v0.0.0-20180712105110-5c3871d89910"
"github.com/prometheus/client_model v0.0.0-20180712105110-5c3871d89910/go.mod"
"github.com/prometheus/common v0.0.0-20181126121408-4724e9255275"
"github.com/prometheus/common v0.0.0-20181126121408-4724e9255275/go.mod"
"github.com/prometheus/procfs v0.0.0-20181204211112-1dc9a6cbc91a"
"github.com/prometheus/procfs v0.0.0-20181204211112-1dc9a6cbc91a/go.mod"
"github.com/sirupsen/logrus v1.4.1"
"github.com/sirupsen/logrus v1.4.1/go.mod"
"github.com/stretchr/objx v0.1.0/go.mod"
"github.com/stretchr/objx v0.1.1/go.mod"
"github.com/stretchr/testify v1.2.2/go.mod"
"github.com/stretchr/testify v1.3.0"
"github.com/stretchr/testify v1.3.0/go.mod"
"golang.org/x/net v0.0.0-20181201002055-351d144fa1fc/go.mod"
"golang.org/x/sync v0.0.0-20181108010431-42b317875d0f"
"golang.org/x/sync v0.0.0-20181108010431-42b317875d0f/go.mod"
"golang.org/x/sys v0.0.0-20180905080454-ebe1bf3edb33"
"golang.org/x/sys v0.0.0-20180905080454-ebe1bf3edb33/go.mod"
"golang.org/x/sys v0.0.0-20190312061237-fead79001313"
"golang.org/x/sys v0.0.0-20190312061237-fead79001313/go.mod"
"gopkg.in/alecthomas/kingpin.v2 v2.2.6"
"gopkg.in/alecthomas/kingpin.v2 v2.2.6/go.mod"
	)
go-module_set_globals
SRC_URI="https://github.com/lusis/exabgp_exporter/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
S=${WORKDIR}/${PN}-${EGIT_COMMIT}

src_compile() {
	CGO_ENABLED=0 go build \
		-ldflags "-X github.com/prometheus/common/version.Version=${PV%_*}
			-X github.com/prometheus/common/version.Revision=${EGIT_COMMIT} \
			-X github.com/prometheus/common/version.Branch=master \
			-X github.com/prometheus/common/version.BuildUser=$(whoami)
			-X github.com/prometheus/common/version.BuildDate=$(date -u +'%FT%T%z')" \
		-o ./bin/${PN} ./cmd/exabgp_exporter/main.go || die
}

src_install() {
	dobin ./bin/${PN}
	dodoc README.md
	systemd_dounit "${FILESDIR}/${PN}.service"
	systemd_newunit "${FILESDIR}/${PN}_at.service" "${PN}@.service"
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
}
