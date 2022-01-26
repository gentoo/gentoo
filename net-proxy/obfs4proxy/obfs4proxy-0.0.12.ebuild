# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

EGO_SUM=(
	"filippo.io/edwards25519 v1.0.0-rc.1.0.20210721174708-390f27c3be20"
	"filippo.io/edwards25519 v1.0.0-rc.1.0.20210721174708-390f27c3be20/go.mod"
	"git.torproject.org/pluggable-transports/goptlib.git v1.0.0"
	"git.torproject.org/pluggable-transports/goptlib.git v1.0.0/go.mod"
	"github.com/dchest/siphash v1.2.1"
	"github.com/dchest/siphash v1.2.1/go.mod"
	"github.com/dsnet/compress v0.0.1"
	"github.com/dsnet/compress v0.0.1/go.mod"
	"github.com/dsnet/golib v0.0.0-20171103203638-1ea166775780/go.mod"
	"github.com/klauspost/compress v1.4.1/go.mod"
	"github.com/klauspost/cpuid v1.2.0/go.mod"
	"github.com/ulikunitz/xz v0.5.6/go.mod"
	"gitlab.com/yawning/bsaes.git v0.0.0-20190805113838-0a714cd429ec"
	"gitlab.com/yawning/bsaes.git v0.0.0-20190805113838-0a714cd429ec/go.mod"
	"gitlab.com/yawning/edwards25519-extra.git v0.0.0-20211229043746-2f91fcc9fbdb"
	"gitlab.com/yawning/edwards25519-extra.git v0.0.0-20211229043746-2f91fcc9fbdb/go.mod"
	"gitlab.com/yawning/utls.git v0.0.12-1"
	"gitlab.com/yawning/utls.git v0.0.12-1/go.mod"
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
	"golang.org/x/crypto v0.0.0-20190325154230-a5d413f7728c/go.mod"
	"golang.org/x/crypto v0.0.0-20210711020723-a769d52b0f97"
	"golang.org/x/crypto v0.0.0-20210711020723-a769d52b0f97/go.mod"
	"golang.org/x/net v0.0.0-20190328230028-74de082e2cca/go.mod"
	"golang.org/x/net v0.0.0-20210226172049-e18ecbb05110"
	"golang.org/x/net v0.0.0-20210226172049-e18ecbb05110/go.mod"
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
	"golang.org/x/sys v0.0.0-20190804053845-51ab0e2deafa/go.mod"
	"golang.org/x/sys v0.0.0-20201119102817-f84b799fce68/go.mod"
	"golang.org/x/sys v0.0.0-20210615035016-665e8c7367d1"
	"golang.org/x/sys v0.0.0-20210615035016-665e8c7367d1/go.mod"
	"golang.org/x/term v0.0.0-20201126162022-7de9c90e9dd1/go.mod"
	"golang.org/x/text v0.3.0/go.mod"
	"golang.org/x/text v0.3.3"
	"golang.org/x/text v0.3.3/go.mod"
	"golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod"
)

go-module_set_globals

DESCRIPTION="An obfuscating proxy supporting Tor's pluggable transport protocol obfs4"
HOMEPAGE="https://gitlab.com/yawning/obfs4"
SRC_URI="https://gitlab.com/yawning/obfs4/-/archive/${P}/obfs4-${P}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

# See https://gitlab.com/yawning/obfs4/-/issues/5#note_573104796 for licence clarification
LICENSE="BSD CC0-1.0 BZIP2 GPL-3+ MIT public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm ~riscv ~x86"

S="${WORKDIR}/obfs4-${P}"

DOCS=( README.md ChangeLog LICENSE-GPL3.txt doc/obfs4-spec.txt )

src_compile() {
	go build -o ${PN}/${PN} ./${PN} || die
}

src_install() {
	default
	dobin ${PN}/${PN}
	doman doc/${PN}.1
}
