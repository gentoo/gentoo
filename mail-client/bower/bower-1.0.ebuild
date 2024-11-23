# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multiprocessing

DESCRIPTION="Curses terminal client for the Notmuch email system"
HOMEPAGE="https://github.com/wangp/bower"
SRC_URI="https://github.com/wangp/bower/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64"

COMMON_DEPEND="app-crypt/gpgme:=
	sys-libs/ncurses:0="
DEPEND="${COMMON_DEPEND}
	dev-lang/mercury"
RDEPEND="${COMMON_DEPEND}
	net-mail/notmuch
	sys-apps/coreutils"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	sed -e "s/-lncursesw -lpanelw/$(pkg-config --libs ncursesw panelw)/" \
		-i src/Mercury.options || die
}

src_compile() {
	emake PARALLEL="--jobs $(makeopts_jobs) --no-strip --very-verbose"
}

src_install() {
	dobin bower
	dodoc AUTHORS NEWS README.md bower.conf.sample
}
