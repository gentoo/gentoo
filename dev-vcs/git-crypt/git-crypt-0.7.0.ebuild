# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Transparent file encryption in git"
HOMEPAGE="https://www.agwa.name/projects/git-crypt/"
SRC_URI="https://www.agwa.name/projects/git-crypt/downloads/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/openssl:=
	dev-vcs/git
"
DEPEND="${RDEPEND}"
BDEPEND="dev-libs/libxslt"

src_configure() {
	# bug #805545, https://github.com/AGWA/git-crypt/issues/232
	append-cppflags -DOPENSSL_API_COMPAT=10101
	tc-export CXX

	# bug #689180
	export ENABLE_MAN=yes
}

src_install() {
	dodir /usr/bin
	emake PREFIX="${D}"/usr install
}
