# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EGO_PN="github.com/containerd/${PN}"

inherit toolchain-funcs

if [[ ${PV} == *9999 ]]; then
	inherit golang-vcs
else
	MY_PV="${PV/_rc/-rc.}"
	EGIT_COMMIT="v${MY_PV}"
	CONTAINERD_COMMIT="cfd0439"
	SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~ppc64"
	inherit golang-vcs-snapshot
fi

DESCRIPTION="A daemon to control runC"
HOMEPAGE="https://containerd.tools"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="+btrfs hardened"

DEPEND="btrfs? ( sys-fs/btrfs-progs )"
RDEPEND="|| ( >=app-emulation/docker-runc-1.0.0_rc4
	>=app-emulation/runc-1.0.0_rc4 )
	sys-libs/libseccomp"

S=${WORKDIR}/${P}/src/${EGO_PN}

src_prepare() {
	default
	if [[ ${PV} != *9999* ]]; then
		sed -i -e "s/git describe --match.*$/echo ${PV})/"\
			-e "s/git rev-parse HEAD.*$/echo $CONTAINERD_COMMIT)/"\
			-e "s/-s -w//" \
			Makefile || die
	fi
}

src_compile() {
	local options=( $(usex btrfs "" "no_btrfs") )
	export GOPATH="${WORKDIR}/${P}" # ${PWD}/vendor
	LDFLAGS=$(usex hardened '-extldflags -fno-PIC' '') emake BUILDTAGS="${options[@]}"
}

src_install() {
	dobin bin/containerd{-shim,-stress,} bin/ctr
}
