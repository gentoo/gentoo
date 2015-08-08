# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KEYWORDS="~amd64"
RESTRICT="strip"
DESCRIPTION="FUSE bindings for Go"
GO_PN=github.com/hanwen/${PN}
HOMEPAGE="https://${GO_PN}"
EGIT_COMMIT="8c85ded140ac1889372a0e22d8d21e3d10a303bd"
SRC_URI="https://${GO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
IUSE=""
DEPEND=">=dev-lang/go-1.3"
RDEPEND=""
S=${WORKDIR}

src_unpack() {
	default_src_unpack
	mkdir -p src/${GO_PN%/*} || die
	mv ${PN}-${EGIT_COMMIT} src/${GO_PN} || die
}

src_prepare() {
	sed -e "s:\(go \${target}\)\(.*\)$:\\1 -x \\2:" \
		-e 's:^for target in "clean" "install" ; do$:for target in "install" ; do:' \
		-e '17,26d' \
		src/${GO_PN}/all.bash > src/${GO_PN}/all.bash.patched || die
}

src_compile() {
	# Create a filtered GOROOT tree out of symlinks,
	# excluding go-fuse, for bug #503324.
	cp -sR /usr/lib/go goroot || die
	rm -rf goroot/src/${GO_PN} || die
	rm -rf goroot/pkg/linux_${ARCH}/${GO_PN} || die
	CGO_CFLAGS="${CFLAGS}" GOROOT="${WORKDIR}/goroot" GOPATH="${WORKDIR}" \
		bash src/${GO_PN}/all.bash.patched || die
}

src_install() {
	insopts -m0644 -p # preserve timestamps for bug 551486
	insinto /usr/lib/go
	doins -r pkg
	insinto /usr/lib/go/src
	rm src/${GO_PN}/all.bash.patched || die
	find src/${GO_PN} -name .gitignore -delete
	doins -r src/*
}
