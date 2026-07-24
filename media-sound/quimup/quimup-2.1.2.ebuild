# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop qmake-utils xdg

DESCRIPTION="Qt client for the music player daemon (MPD)"
HOMEPAGE="https://quimup.sourceforge.io"
SRC_URI="https://sourceforge.net/projects/quimup/files/${PN^}%20${PV}/${P/-/_}_source.tar.gz"
S="${WORKDIR}/${P/-/_}_source"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-qt/qtbase:6[gui,network,widgets]
	media-libs/libmpdclient
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-2.1.2-clang.patch
)

# bug 947318
DOCS=( RPM_DEB_build/share/doc/quimup/{changelog,faq,readme} )

src_prepare() {
	default

	# cleanup sources
	rm -r build .qmake.stash Makefile || die
}

src_configure() {
	eqmake6
}

src_install() {
	default
	dobin ${PN}

	local x
	for x in 32 64 128 scalable; do
		doicon -s ${x} RPM_DEB_build/share/icons/hicolor/${x}*/*
	done

	domenu RPM_DEB_build/share/applications/${PN^}.desktop
}
