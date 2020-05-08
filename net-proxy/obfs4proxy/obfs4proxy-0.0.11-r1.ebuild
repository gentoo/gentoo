# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module

DESCRIPTION="An obfuscating proxy supporting Tor's pluggable transport protocol obfs4"
HOMEPAGE="https://gitlab.com/yawning/obfs4"

EGO_SUM=(
	"git.schwanenlied.me/yawning/bsaes.git v0.0.0-20190320102049-26d1add596b6"
	"git.schwanenlied.me/yawning/bsaes.git v0.0.0-20190320102049-26d1add596b6/go.mod"
	"git.torproject.org/pluggable-transports/goptlib.git v1.0.0"
	"git.torproject.org/pluggable-transports/goptlib.git v1.0.0/go.mod"
	"github.com/agl/ed25519 v0.0.0-20170116200512-5312a6153412"
	"github.com/agl/ed25519 v0.0.0-20170116200512-5312a6153412/go.mod"
	"github.com/dchest/siphash v1.2.1"
	"github.com/dchest/siphash v1.2.1/go.mod"
	"github.com/dsnet/compress v0.0.1"
	"github.com/dsnet/compress v0.0.1/go.mod"
	"github.com/dsnet/golib v0.0.0-20171103203638-1ea166775780/go.mod"
	"github.com/klauspost/compress v1.4.1/go.mod"
	"github.com/klauspost/cpuid v1.2.0/go.mod"
	"github.com/ulikunitz/xz v0.5.6/go.mod"
	"gitlab.com/yawning/utls.git v0.0.11-1"
	"gitlab.com/yawning/utls.git v0.0.11-1/go.mod"
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
	"golang.org/x/crypto v0.0.0-20190325154230-a5d413f7728c"
	"golang.org/x/crypto v0.0.0-20190325154230-a5d413f7728c/go.mod"
	"golang.org/x/net v0.0.0-20190328230028-74de082e2cca"
	"golang.org/x/net v0.0.0-20190328230028-74de082e2cca/go.mod"
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
	"golang.org/x/sys v0.0.0-20190329044733-9eb1bfa1ce65"
	"golang.org/x/sys v0.0.0-20190329044733-9eb1bfa1ce65/go.mod"
	"golang.org/x/text v0.3.0"
	"golang.org/x/text v0.3.0/go.mod"
	)
go-module_set_globals
SRC_URI="https://gitlab.com/yawning/obfs4/-/archive/${P}/obfs4-${P}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

LICENSE="BSD BSD-2 CC0-1.0 BZIP2 GPL-3+ MIT public-domain"
SLOT="0"
KEYWORDS="amd64 ~arm ~x86"

S="${WORKDIR}/obfs4-${P}"

DOCS=( README.md ChangeLog doc/obfs4-spec.txt )

src_compile() {
	go build -o ${PN}/${PN} ./${PN} || die
}

src_install() {
	default
	dobin ${PN}/${PN}
	doman doc/"${PN}.1"
}
