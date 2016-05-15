# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3

DESCRIPTION="native bindings for the FUSE kernel module"
HOMEPAGE="https://github.com/hanwen/go-fuse"
EGIT_REPO_URI="https://github.com/hanwen/go-fuse.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=dev-lang/go-1.3"
RDEPEND=""

RESTRICT="strip"

GO_PN="github.com/hanwen/${PN}"
EGIT_CHECKOUT_DIR="${S}/src/${GO_PN}"

export GOPATH="${S}"

src_compile() {
	local d
#no examples right now
#    example/hello example/loopback example/zipfs \
#    example/multizip example/unionfs example/memfs \
#    example/autounionfs ; \
#or tests
#fuse/test
	for d in fuse fuse/pathfs zipfs unionfs; do
		go build -v -x -work ${GO_PN}/${d} || die
	done
}

src_install() {
	local d
	for d in fuse fuse/pathfs zipfs unionfs; do
		go install -v -x -work ${GO_PN}/${d} || die
	done

	insinto /usr/lib/go/
	doins -r "${S}/pkg"
	insinto "/usr/lib/go/src/${GO_PN}/"
	#for this ebuild, to fix bug #503324 I have limited what is installed
	#another possible solution would have been using adddeny to the
	#hide installed filed during build
	egit_clean "${S}/src/${GO_PN}"
	doins -r "${S}/src/${GO_PN}/fuse"
	doins -r "${S}/src/${GO_PN}/splice"
}
