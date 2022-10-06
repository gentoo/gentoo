# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit savedconfig toolchain-funcs

DESCRIPTION="Dynamic virtual terminal manager"
HOMEPAGE="https://www.brain-dump.org/projects/dvtm/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="
		https://github.com/martanne/dvtm
		https://git.sr.ht/~martanne/dvtm
		https://repo.or.cz/dvtm.git
	"
else
	SRC_URI="https://www.brain-dump.org/projects/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~x86"
fi

LICENSE="MIT"
SLOT="0"

RDEPEND=">=sys-libs/ncurses-6.1:=[unicode(+)]"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}"/${PN}-9999-gentoo.patch
	"${FILESDIR}"/${PN}-0.15-stop-installing-terminfo.patch
)

src_prepare() {
	default

	restore_config config.h
}

src_compile() {
	tc-export PKG_CONFIG
	emake CC="$(tc-getCC)" ${PN}
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" STRIP=true install

	insinto /usr/share/${PN}
	newins config.h ${PF}.config.h

	dodoc README.md

	save_config config.h
}

pkg_postinst() {
	elog "This ebuild has support for user defined configs"
	elog "Please read this ebuild for more details and re-emerge as needed"
	elog "if you want to add or remove functionality for ${PN}"
}
