# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="HTML reference manual for Audacity"
HOMEPAGE="https://www.audacityteam.org/"

if [[ ${PV} = 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/audacity/audacity-manual.git"
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/help"
	SRC_URI="amd64? ( https://github.com/audacity/audacity-manual/releases/download/v${PV}/audacity-manual-${PV}.tar.gz )"
fi

LICENSE="CC-BY-3.0"
SLOT="0"

src_install() {
	docinto html
	dodoc -r "${S}"/manual/{m,man}
	dodoc "${S}"/manual/{favicon.ico,index.html,quick_help.html}
	dosym ../../doc/${PF}/html /usr/share/${PN}/help/manual
}
