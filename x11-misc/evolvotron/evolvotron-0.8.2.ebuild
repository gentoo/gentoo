# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop qmake-utils xdg

DESCRIPTION="Generative art image evolver"
HOMEPAGE="https://www.timday.com/share/evolvotron/"
SRC_URI="https://github.com/WickedSmoke/evolvotron/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	dev-libs/boost:=
	dev-qt/qtbase:6[gui,widgets]
"
DEPEND="${RDEPEND}"

PATCHES=(
	# to be removed at the next release 0.8.3
	"${FILESDIR}"/${PN}-0.8.2-fix-desktop.patch
)

HTML_DOCS=( evolvotron.html )

src_configure() {
	eqmake6 main.pro
}

src_install() {
	local bin
	for bin in ${PN}{,_mutate,_render}; do
		dobin ${bin}/${bin}
	done

	for x in 48 128; do
		doicon -s ${x} dist/icon-${x}.png
	done

	domenu dist/${PN}.desktop

	doman man/man1/*
	einstalldocs
}
