# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/go-fuse/go-fuse-0_p20150422.ebuild,v 1.2 2015/06/10 08:09:56 zmedico Exp $

EAPI=5

KEYWORDS="~amd64"
RESTRICT="strip"
DESCRIPTION="FUSE bindings for Go"
GO_PN=github.com/hanwen/${PN}
HOMEPAGE="https://${GO_PN}"
EGIT_COMMIT="ffed29ec8b88f61c1b8954134cc48ef03bb26ce1"
SRC_URI="https://${GO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-lang/go-1.3"
RDEPEND=""

src_unpack() {
	default_src_unpack
	mkdir -p "${S}/src/${GO_PN%/*}" || die
	mv ${PN}-${EGIT_COMMIT} "${S}/src/${GO_PN}" || die
	find "${S}" -name .gitignore -delete || die
}

call_go() {
	local d
	for d in fuse fuse/pathfs zipfs unionfs; do
		GOROOT="${GOROOT}" GOPATH="${S}" \
			go "${1}" -v -x -work ${GO_PN}/${d} || die
	done
}

src_compile() {
	# Create a filtered GOROOT tree out of symlinks,
	# excluding go-fuse, for bug #503324.
	GOROOT="${WORKDIR}/goroot"
	cp -sR /usr/lib/go "${GOROOT}" || die
	rm -rf "${GOROOT}/src/${GO_PN}" || die
	rm -rf "${GOROOT}/pkg/linux_${ARCH}/${GO_PN}" || die
	call_go build
}

src_install() {
	call_go install
	insopts -m0644 -p # preserve timestamps for bug 551486
	insinto /usr/lib/go
	doins -r pkg src
}
