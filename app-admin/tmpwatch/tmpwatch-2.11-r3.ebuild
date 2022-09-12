# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Files which haven't been accessed are removed from specified directories"
HOMEPAGE="https://pagure.io/tmpwatch"
SRC_URI="https://releases.pagure.org/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 ~ia64 ppc ppc64 sparc x86"
IUSE="selinux"

# psmisc for fuser
DEPEND="
	!kernel_Darwin? ( sys-process/psmisc )
"
RDEPEND="
	${DEPEND}
	selinux? ( sec-policy/selinux-tmpreaper )
"

PATCHES=(
	"${FILESDIR}/${P}-boottime.patch"
)

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	default

	dosbin tmpwatch
	doman tmpwatch.8

	exeinto /etc/cron.daily
	newexe "${FILESDIR}/${PN}.cron" "${PN}"
}
