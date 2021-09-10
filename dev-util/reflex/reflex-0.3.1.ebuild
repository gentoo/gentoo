# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

EGO_SUM=(
	"github.com/creack/pty v1.1.11"
	"github.com/creack/pty v1.1.11/go.mod"
	"github.com/fsnotify/fsnotify v1.4.7"
	"github.com/fsnotify/fsnotify v1.4.7/go.mod"
	"github.com/kballard/go-shellquote v0.0.0-20180428030007-95032a82bc51"
	"github.com/kballard/go-shellquote v0.0.0-20180428030007-95032a82bc51/go.mod"
	"github.com/kr/pretty v0.1.0"
	"github.com/kr/pretty v0.1.0/go.mod"
	"github.com/kr/pty v1.1.1/go.mod"
	"github.com/kr/text v0.1.0"
	"github.com/kr/text v0.1.0/go.mod"
	"github.com/ogier/pflag v0.0.1"
	"github.com/ogier/pflag v0.0.1/go.mod"
	"golang.org/x/sys v0.0.0-20180909124046-d0be0721c37e"
	"golang.org/x/sys v0.0.0-20180909124046-d0be0721c37e/go.mod"
)

go-module_set_globals

DESCRIPTION="A small tool to watch a directory and rerun a command when certain files change"
HOMEPAGE="https://github.com/cespare/reflex"
SRC_URI="https://github.com/cespare/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
		${EGO_SUM_SRC_URI}"

LICENSE="MIT BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_compile() {
	local mygoargs=(
		-v
		-work
		-x
		-tags release
		-ldflags "-X main.version=${PV}"
		-asmflags "-trimpath=${S}"
		-gcflags "-trimpath=${S}"
	)

	go build "${mygoargs[@]}" -o reflex || die
}

src_test() {
	go test -v -work -x || die
}

src_install() {
	dobin reflex
}
