# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN=${PN%-*}
MY_P=${MY_PN}-${PV}

DESCRIPTION="Terminfo for st"
HOMEPAGE="https://st.suckless.org/"
SRC_URI="https://dl.suckless.org/st/${MY_P}.tar.gz"

LICENSE="MIT-with-advertising"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc64 ~x86"
RESTRICT="test"

DEPEND=">=sys-libs/ncurses-6.0:0="

S="${WORKDIR}/${MY_P}"

src_prepare() {
	mkdir terminfo || die "Failed to create terminfo directory"
	default
}

src_configure() {
	:
}

src_compile() {
	tic -sxo terminfo st.info || die "Failed to translate terminfo file"
}

src_install() {
	insinto "/usr/share/${MY_PN}"
	doins -r terminfo

	newenvd - "51${MY_PN}" <<-_EOF_
		TERMINFO_DIRS="/usr/share/${MY_PN}/terminfo"
		COLON_SEPARATED="TERMINFO_DIRS"
	_EOF_
}

pkg_postinst() {
	ewarn "Please run env-update and then source /etc/profile in any open shells"
	ewarn "to update terminfo settings. Relogin to update it for any new shells."
}
