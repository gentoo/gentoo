# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Gopass Browser Bindings"
HOMEPAGE="https://github.com/gopasspw/gopass-jsonapi"
SRC_URI="https://github.com/gopasspw/gopass-jsonapi/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~ajak/distfiles/${CATEGORY}/${PN}/${P}-deps.tar.xz"

LICENSE="MIT Apache-2.0 BSD MPL-2.0 BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

DEPEND=">=dev-lang/go-1.16"
RDEPEND="
	dev-vcs/git
	>=app-crypt/gnupg-2
"

PATCHES=(
	"${FILESDIR}/${PN}-1.15.3-skip-test.patch"
)
