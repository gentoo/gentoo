# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Gopass Browser Bindings"
HOMEPAGE="https://github.com/gopasspw/gopass-jsonapi"
SRC_URI="https://github.com/gopasspw/gopass-jsonapi/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-golang-dist/${PN}/releases/download/v${PV}/${P}-vendor.tar.xz"

LICENSE="MIT"
# Dependent licenses
LICENSE+=" Apache-2.0 BSD BSD-2 MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

RDEPEND="
	dev-vcs/git
	>=app-crypt/gnupg-2
"
BDEPEND=">=dev-lang/go-1.24.1"

PATCHES=(
	"${FILESDIR}/${PN}-1.15.3-skip-test.patch"
)

src_prepare() {
	default

	# remove stripping from Makefile (bug #960078)
	sed -e '/ldflags/s/-s //g' -i Makefile || die
}
