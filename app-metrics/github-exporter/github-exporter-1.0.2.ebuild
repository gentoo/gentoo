# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module systemd
DESCRIPTION="Github statistics exporter for prometheus"
HOMEPAGE="https://github.com/infinityworks/github-exporter"

EGO_SUM=(
	"github.com/beorn7/perks v0.0.0-20180321164747-3a771d992973"
	"github.com/beorn7/perks v0.0.0-20180321164747-3a771d992973/go.mod"
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/davecgh/go-spew v1.1.1"
	"github.com/davecgh/go-spew v1.1.1/go.mod"
	"github.com/fatih/structs v1.1.0"
	"github.com/fatih/structs v1.1.0/go.mod"
	"github.com/golang/protobuf v1.2.0"
	"github.com/golang/protobuf v1.2.0/go.mod"
	"github.com/infinityworks/go-common v0.0.0-20170820165359-7f20a140fd37"
	"github.com/infinityworks/go-common v0.0.0-20170820165359-7f20a140fd37/go.mod"
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
	"github.com/sirupsen/logrus v1.4.2"
	"github.com/sirupsen/logrus v1.4.2/go.mod"
	"github.com/steinfletcher/apitest v1.3.8"
	"github.com/steinfletcher/apitest v1.3.8/go.mod"
	"github.com/stretchr/objx v0.1.0/go.mod"
	"github.com/stretchr/objx v0.1.1/go.mod"
	"github.com/stretchr/testify v1.2.2"
	"github.com/stretchr/testify v1.2.2/go.mod"
	"github.com/stretchr/testify v1.3.0"
	"github.com/stretchr/testify v1.3.0/go.mod"
	"github.com/tomnomnom/linkheader v0.0.0-20180905144013-02ca5825eb80"
	"github.com/tomnomnom/linkheader v0.0.0-20180905144013-02ca5825eb80/go.mod"
	"golang.org/x/net v0.0.0-20181201002055-351d144fa1fc/go.mod"
	"golang.org/x/sync v0.0.0-20181108010431-42b317875d0f"
	"golang.org/x/sync v0.0.0-20181108010431-42b317875d0f/go.mod"
	"golang.org/x/sys v0.0.0-20190422165155-953cdadca894"
	"golang.org/x/sys v0.0.0-20190422165155-953cdadca894/go.mod"
	)
go-module_set_globals
SRC_URI="https://github.com/infinityworks/github-exporter/archive/${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

LICENSE="MIT Apache-2.0 BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="acct-group/github-exporter
	acct-user/github-exporter"

src_compile() {
	go build . || die "build failed"
}

src_install() {
	dobin ${PN}
	dodoc *.md
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		elog "Before you can use ${PN}, you must configure it in"
		elog "${EROOT}/etc/conf.d/${PN}"
	fi
}
