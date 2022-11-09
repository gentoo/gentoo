# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

MY_PV="$(ver_cut 1-3)T$(ver_cut 4-7)Z"
MY_PV=${MY_PV//./-}
EGIT_COMMIT=1513d76ca9d3a2cddda40d0e6e50be164b894889

DESCRIPTION="Minio client provides alternatives for ls, cat on cloud storage and filesystems"
HOMEPAGE="https://github.com/minio/mc"
SRC_URI="https://github.com/minio/mc/archive/RELEASE.${MY_PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="!!app-misc/mc"

S="${WORKDIR}/${PN}-RELEASE.${MY_PV}"

src_prepare() {
	default
	sed -i \
		-e "s/time.Now().UTC().Format(time.RFC3339)/\"${VERSION}\"/" \
		-e "s/-s -w//" \
		-e "/time/d" \
		-e "s/+ commitID()/+ \"${EGIT_COMMIT}\"/" \
		buildscripts/gen-ldflags.go || die
}

src_compile() {
	MC_RELEASE="${MY_PV}" \
	go build -trimpath --ldflags "$(go run buildscripts/gen-ldflags.go)" -o ${PN} || die
}

src_install() {
	dobin mc
	dodoc -r README.md CONTRIBUTING.md docs
}
