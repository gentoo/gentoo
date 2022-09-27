# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module systemd

MY_PV="$(ver_cut 1-3)T$(ver_cut 4-7)Z"
MY_PV=${MY_PV//./-}
EGIT_COMMIT=feafccf0072a9b5fbddc33553890ff56cb2f83b6

DESCRIPTION="An Amazon S3 compatible object storage server"
HOMEPAGE="https://github.com/minio/minio"
SRC_URI="https://github.com/minio/minio/archive/RELEASE.${MY_PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~amd64-linux"

RESTRICT="test"

DEPEND="
	acct-user/minio
	acct-group/minio
"

S="${WORKDIR}/${PN}-RELEASE.${MY_PV}"

src_prepare() {
	default

	sed -i \
		-e "s/time.Now().UTC().Format(time.RFC3339)/\"${MY_PV}\"/" \
		-e "s/-s //" \
		-e "/time/d" \
		-e "s/+ commitID()/+ \"${EGIT_COMMIT}\"/" \
		buildscripts/gen-ldflags.go || die
}

src_compile() {
	MINIO_RELEASE="${MY_PV}"
	go run buildscripts/gen-ldflags.go || die
	go build \
		--ldflags "$(go run buildscripts/gen-ldflags.go)" -o ${PN} || die
}

src_install() {
	dobin minio

	insinto /etc/default
	doins "${FILESDIR}"/minio.default

	dodoc -r README.md CONTRIBUTING.md docs

	systemd_dounit "${FILESDIR}"/minio.service
	newinitd "${FILESDIR}"/minio.initd minio

	keepdir /var/{lib,log}/minio
	fowners minio:minio /var/{lib,log}/minio
}
