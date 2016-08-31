# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit golang-build

EGO_SRC=git.torproject.org/pluggable-transports/obfs4.git
EGO_PN=${EGO_SRC}/...

if [[ ${PV} == "9999" ]];
then
	inherit golang-vcs
else
	KEYWORDS="~amd64 ~arm"
	EGIT_COMMIT="${P}"
	SRC_URI="https://github.com/Yawning/obfs4/archive/${P}.tar.gz -> ${P}.tar.gz"
	inherit golang-vcs-snapshot
fi

DESCRIPTION="An obfuscating proxy supporting Tor's pluggable transport protocol obfs4"
HOMEPAGE="https://github.com/Yawning/obfs4"

LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND="dev-go/ed25519
	dev-go/go-crypto
	dev-go/go-net
	dev-go/goptlib
	dev-go/siphash"
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
