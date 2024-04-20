# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

COMMIT_HASH="71a9e8bae308aed5aa59e02875122a728cdb5dba"

DESCRIPTION="A tiny tool to allow the creation of idmapped mounts"
HOMEPAGE="https://github.com/brauner/mount-idmapped"
SRC_URI="https://github.com/brauner/mount-idmapped/archive/${COMMIT_HASH}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT_HASH}"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=sys-kernel/linux-headers-5.12
"

src_configure() {
	tc-export CC
}

src_compile() {
	"${CC}" ${CFLAGS} ${LDFLAGS} ${PN}.c -o "${PN}" || die
}

src_install() {
	local -a DOCS=(
		README.md
	)
	default
	dobin ${PN}
}
