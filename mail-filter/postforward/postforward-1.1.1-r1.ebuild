# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Postfix Sender Rewriting Scheme forwarding agent"
HOMEPAGE="https://github.com/zoni/postforward"
SRC_URI="https://github.com/zoni/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="mail-filter/postsrsd"

PATCHES=(
	"${FILESDIR}/${P}-apply-sendmail-path.patch"
)

src_unpack() {
	# This package has no dependencies, but go-module_src_unpack requires this directory
	mkdir -p "${S}/vendor" || die

	go-module_src_unpack
}

src_prepare() {
	default

	# Dynamically fix EPREFIX lines made by ${PN}_apply-sendmail-path.patch
	sed -e "s/@GENTOO_PORTAGE_EPREFIX@/${EPREFIX}/" -i ${PN}.go || die
}

src_compile() {
	ego build -o ${PN} ${PN}.go
}

src_install() {
	einstalldocs
	dosbin "${PN}"
}
