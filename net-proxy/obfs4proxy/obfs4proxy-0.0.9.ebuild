# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_SRC=gitlab.com/yawning/obfs4.git
EGO_PN=${EGO_SRC}/...

EGO_VENDOR=(
	"github.com/dsnet/compress v0.0.1"
	"gitlab.com/yawning/utls.git v0.0.9-2 gitlab.com/yawning/utls/-"
	# Newer versions of packages which are in the tree
	"golang.org/x/crypto b8fe1690c61389d7d2a8074a507d1d40c5d30448 github.com/golang/crypto"
	"golang.org/x/net ed066c81e75eba56dd9bd2139ade88125b855585 github.com/golang/net"
	"golang.org/x/sys afcc84fd7533758f95a6e93ae710aa945a0b7e73 github.com/golang/sys"
)

inherit golang-build golang-vcs-snapshot

DESCRIPTION="An obfuscating proxy supporting Tor's pluggable transport protocol obfs4"
HOMEPAGE="https://gitlab.com/yawning/obfs4"
SRC_URI="https://gitlab.com/yawning/obfs4/-/archive/${P}/obfs4-${P}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND=">=dev-go/ed25519-0_pre20170117
	>=dev-go/go-text-0.3.0
	>=dev-go/goptlib-1.0.0
	>=dev-go/siphash-1.2.1"
RDEPEND=""

src_compile() {
	golang-build_src_compile
	local binfile=$(find "${T}" -name a.out)
	[[ -x ${binfile} ]] || die "a.out not found"
	cp -a ${binfile} obfs4proxy
}

src_install() {
	default
	dobin obfs4proxy || die "install failed"
	cd src/${EGO_SRC}
	doman doc/obfs4proxy.1 || die "install failed"
	dodoc README.md ChangeLog doc/obfs4-spec.txt || die "install failed"
}
