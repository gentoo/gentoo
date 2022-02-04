# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Terminfo for x11-terms/st"
HOMEPAGE="https://st.suckless.org/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.suckless.org/st"
else
	SRC_URI="https://dl.suckless.org/st/st-${PV}.tar.gz"
	S="${WORKDIR}/st-${PV}"
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~m68k ~ppc64 ~riscv ~x86"
fi

LICENSE="MIT-with-advertising"
SLOT="0"

BDEPEND=">=sys-libs/ncurses-6.0"

RESTRICT="test"

src_prepare() {
	mkdir -v terminfo || die "Failed to create terminfo directory"
	default
}

src_configure() {
	:
}

src_compile() {
	tic -sxo terminfo st.info || die "Failed to translate terminfo file"
}

src_install() {
	insinto "/usr/share/st"
	doins -r terminfo

	newenvd - "51${PN}" <<-_EOF_
		TERMINFO_DIRS="/usr/share/st/terminfo"
		COLON_SEPARATED="TERMINFO_DIRS"
	_EOF_
}

pkg_postinst() {
	ewarn "Please run env-update and then source /etc/profile in any open shells"
	ewarn "to update terminfo settings. Relogin to update it for any new shells."
}
