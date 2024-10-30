# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Lib that implements the client side of the SMTP protocol"
HOMEPAGE="https://libesmtp.github.io/"
if [[ "${PV}" == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/libesmtp/libESMTP.git"
else
	SRC_URI="https://github.com/libesmtp/libESMTP/archive/v${PV/_}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/libESMTP-${PV}"

	KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"
fi

LICENSE="LGPL-2.1+ GPL-2+"
# 0/7 was a snapshot before 1.1.0
# The SONAME was fixed just before the 1.1.0 release was made
# ... but a patch was needed to get it exactly right too
# so, we're on 0/8 now, even though ABI compatibility actually remained
# in terms of symbols with the original <1.1.0.
SLOT="0/8"
IUSE="ssl static-libs threads"

RDEPEND="ssl? ( >=dev-libs/openssl-1.1.0:0= )"
DEPEND="${RDEPEND}"

DOCS=( docs/{authors,bugreport,ChangeLog,faq,NEWS}.md README.md )

PATCHES=(
	"${FILESDIR}"/${P}-fix-soname.patch
	"${FILESDIR}"/${P}-fix-build-with-clang16.patch
)

src_configure() {
	local emesonargs=(
		-Ddefault_library="$(usex static-libs both shared)"
		$(meson_feature ssl tls)
		$(meson_feature threads pthreads)
	)
	meson_src_configure
}
