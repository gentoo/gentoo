# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module
EGIT_COMMIT=7825f115dd3ed9f623377821c0351d1eb7aa3a5a

DESCRIPTION="A tool for extracting metrics from application logs"
HOMEPAGE="https://github.com/google/mtail"

SRC_URI="https://github.com/google/mtail/archive/v${PV/_/-}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~zmedico/dist/${P}-tidy.patch.xz
	https://dev.gentoo.org/~zmedico/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0 MPL-2.0 BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples"

RDEPEND="!app-misc/mtail"

S="${WORKDIR}/${PN}-${PV/_/-}"

RESTRICT+=" test"

src_unpack() {
	unpack ${A}
	cd "${S}" || die
	eapply "${WORKDIR}/${P}-tidy.patch"
}

src_prepare() {
	default
	sed \
		-e '/go get/d' \
		-e 's|^branch :=.*|branch := master|' \
		-e "s|^version :=.*|version := v${PV/_/-}|" \
		-e "s|^revision :=.*|revision := ${EGIT_COMMIT}|" \
		-e "s|^release :=.*|release := v${PV/_/-}|" \
		-i Makefile || die
}

src_compile() {
	emake
}

src_install() {
	dobin mtail
	dodoc CONTRIBUTING.md README.md TODO
	if use examples; then
		insinto "/usr/share/doc/${PF}"
		doins -r examples
	fi
}
