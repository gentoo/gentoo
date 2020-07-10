# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module systemd

DESCRIPTION="Process exporter for prometheus"
HOMEPAGE="https://github.com/ncabatoff/process-exporter"

EGO_SUM=(
	"github.com/beorn7/perks v0.0.0-20180321164747-3a771d992973"
	"github.com/beorn7/perks v0.0.0-20180321164747-3a771d992973/go.mod"
	"github.com/golang/protobuf v1.1.0"
	"github.com/golang/protobuf v1.1.0/go.mod"
	"github.com/google/go-cmp v0.3.1"
	"github.com/google/go-cmp v0.3.1/go.mod"
	"github.com/kr/pretty v0.1.0"
	"github.com/kr/pretty v0.1.0/go.mod"
	"github.com/kr/pty v1.1.1/go.mod"
	"github.com/kr/text v0.1.0"
	"github.com/kr/text v0.1.0/go.mod"
	"github.com/matttproud/golang_protobuf_extensions v1.0.1"
	"github.com/matttproud/golang_protobuf_extensions v1.0.1/go.mod"
	"github.com/ncabatoff/fakescraper v0.0.0-20161023141611-15938421d91a"
	"github.com/ncabatoff/fakescraper v0.0.0-20161023141611-15938421d91a/go.mod"
	"github.com/ncabatoff/go-seq v0.0.0-20180805175032-b08ef85ed833"
	"github.com/ncabatoff/go-seq v0.0.0-20180805175032-b08ef85ed833/go.mod"
	"github.com/prometheus/client_golang v0.8.0"
	"github.com/prometheus/client_golang v0.8.0/go.mod"
	"github.com/prometheus/client_model v0.0.0-20180712105110-5c3871d89910"
	"github.com/prometheus/client_model v0.0.0-20180712105110-5c3871d89910/go.mod"
	"github.com/prometheus/common v0.0.0-20180801064454-c7de2306084e"
	"github.com/prometheus/common v0.0.0-20180801064454-c7de2306084e/go.mod"
	"github.com/prometheus/procfs v0.0.12-0.20200505152635-9654394ca94a"
	"github.com/prometheus/procfs v0.0.12-0.20200505152635-9654394ca94a/go.mod"
	"github.com/prometheus/procfs v0.0.12-0.20200513160535-c6ff04bafc38"
	"github.com/prometheus/procfs v0.0.12-0.20200513160535-c6ff04bafc38/go.mod"
	"golang.org/x/sync v0.0.0-20190911185100-cd5d95a43a6e"
	"golang.org/x/sync v0.0.0-20190911185100-cd5d95a43a6e/go.mod"
	"golang.org/x/sys v0.0.0-20200106162015-b016eb3dc98e"
	"golang.org/x/sys v0.0.0-20200106162015-b016eb3dc98e/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/check.v1 v1.0.0-20180628173108-788fd7840127"
	"gopkg.in/check.v1 v1.0.0-20180628173108-788fd7840127/go.mod"
	"gopkg.in/yaml.v2 v2.2.1"
	"gopkg.in/yaml.v2 v2.2.1/go.mod"
	)
go-module_set_globals
SRC_URI="https://github.com/ncabatoff/process-exporter/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	emake build
}

src_install() {
	dobin ${PN}
dodoc *.md
	insinto /etc/${PN}
	doins packaging/conf/all.yaml
	systemd_dounit packaging/${PN}.service
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	keepdir /var/log/${PN}
}
