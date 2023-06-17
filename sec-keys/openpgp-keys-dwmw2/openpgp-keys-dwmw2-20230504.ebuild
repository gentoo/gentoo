# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP key for David Woodhouse"
HOMEPAGE="https://www.kernel.org/category/signatures.html"
SRC_URI="https://kernel.org/.well-known/openpgpkey/hu/163ux8fk184q7f9reyj4huqggwnwb6w7?l=dwmw2 -> dwmw2@kernel.org.key"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ppc64 ~riscv x86"

S=${WORKDIR}

src_unpack() {
	:
}

src_install() {
	insinto /usr/share/openpgp-keys
	doins "${DISTDIR}/dwmw2@kernel.org.key"
}
