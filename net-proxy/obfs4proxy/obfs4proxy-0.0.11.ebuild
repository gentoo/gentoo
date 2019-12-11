# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_SRC=gitlab.com/yawning/obfs4.git
EGO_PN=${EGO_SRC}/...

EGO_VENDOR=(
	"github.com/dsnet/compress v0.0.1"
	"gitlab.com/yawning/utls.git v0.0.11-1 gitlab.com/yawning/utls/-"
	"git.schwanenlied.me/yawning/bsaes.git 26d1add596b6d800bdeeb3bc3b2c7b316c056b6d git.schwanenlied.me/yawning/bsaes"
	# Newer versions of packages which are in the tree
	"golang.org/x/crypto a5d413f7728c81fb97d96a2b722368945f651e78 github.com/golang/crypto"
	"golang.org/x/net 74de082e2cca95839e88aa0aeee5aadf6ce7710f github.com/golang/net"
	"golang.org/x/sys 9eb1bfa1ce65ae8a6ff3114b0aaf9a41a6cf3560 github.com/golang/sys"
)

inherit golang-build golang-vcs-snapshot

DESCRIPTION="An obfuscating proxy supporting Tor's pluggable transport protocol obfs4"
HOMEPAGE="https://gitlab.com/yawning/obfs4"
SRC_URI="https://gitlab.com/yawning/obfs4/-/archive/${P}/obfs4-${P}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="BSD BSD-2 CC0-1.0 BZIP2 GPL-3+ MIT public-domain"
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
	dobin obfs4proxy
	cd src/${EGO_SRC}
	doman doc/obfs4proxy.1
	dodoc README.md ChangeLog doc/obfs4-spec.txt
}
