# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

MY_PV="${PV/_rc/}"
MY_PV="${MY_PV/_/-}"

DESCRIPTION="A shell parser, formatter, and interpreter (sh/bash/mksh)"
HOMEPAGE="https://github.com/mvdan/sh"
EGO_PN="github.com/mvdan/sh"
EGO_VENDOR=(
	"github.com/kr/pretty v0.1.0"
	"github.com/pkg/diff 531926345625"
	"github.com/rogpeppe/go-internal v1.5.0"
	"github.com/stretchr/testify v1.4.0"
	"golang.org/x/crypto 34f69633bfdc github.com/golang/crypto"
	"golang.org/x/sync cd5d95a43a6e github.com/golang/sync"
	"golang.org/x/sys 543471e840be github.com/golang/sys"
	"golang.org/x/xerrors 1b5146add898 github.com/golang/xerrors"
	"gopkg.in/check.v1 41f04d3bba15 github.com/go-check/check"
	"mvdan.cc/editorconfig 890940e3f00e github.com/mvdan/editorconfig"
)

SRC_URI="https://github.com/mvdan/sh/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz $(go-module_vendor_uris)"

S="${WORKDIR}/sh-${MY_PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

src_compile() {
	go build -v -work -x "./cmd/shfmt"
}

src_install() {
	go install -v -work -x "./cmd/shfmt"
	dobin shfmt
}
