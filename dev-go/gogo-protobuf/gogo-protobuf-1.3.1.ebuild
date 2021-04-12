# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module

DESCRIPTION="Protocol Buffers for Go with Gadgets"
HOMEPAGE="https://github.com/gogo/protobuf"

EGO_SUM=(
	"github.com/kisielk/errcheck v1.1.0"
	"github.com/kisielk/errcheck v1.1.0/go.mod"
	"github.com/kisielk/errcheck v1.2.0"
	"github.com/kisielk/errcheck v1.2.0/go.mod"
	"github.com/kisielk/gotool v1.0.0"
	"github.com/kisielk/gotool v1.0.0/go.mod"
	"golang.org/x/tools v0.0.0-20180221164845-07fd8470d635"
	"golang.org/x/tools v0.0.0-20180221164845-07fd8470d635/go.mod"
	"golang.org/x/tools v0.0.0-20181030221726-6c7e314b6563"
	"golang.org/x/tools v0.0.0-20181030221726-6c7e314b6563/go.mod"
	)
go-module_set_globals
SRC_URI="https://github.com/gogo/protobuf/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RESTRICT+=" test"

S="${WORKDIR}/protobuf-${PV}"

src_compile() {
	GOBIN="${S}/bin" emake install
}

src_install() {
	dobin bin/*
	dodoc README
}
