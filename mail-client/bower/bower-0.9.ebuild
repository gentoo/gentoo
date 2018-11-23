# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multiprocessing

DESCRIPTION="A curses terminal client for the Notmuch email system"
HOMEPAGE="https://github.com/wangp/bower"
SRC_URI="https://github.com/wangp/bower/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="app-crypt/gpgme:=
	>=dev-lang/mercury-11.07
	sys-libs/ncurses:0="
RDEPEND="app-crypt/gpgme:=
	net-mail/notmuch
	sys-apps/coreutils
	sys-libs/ncurses:0="

src_prepare() {
	if has_version "sys-libs/ncurses:0[tinfo]" ; then
		echo "MLLIBS-bower += -ltinfow" >> src/Mercury.params || die
	fi
	eapply_user
}

src_compile() {
	emake PARALLEL="--jobs $(makeopts_jobs) --no-strip --very-verbose"
}

src_install() {
	dobin bower
	dodoc AUTHORS NEWS README.md bower.conf.sample
}
