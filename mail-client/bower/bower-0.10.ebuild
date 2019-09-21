# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multiprocessing

DESCRIPTION="A curses terminal client for the Notmuch email system"
HOMEPAGE="https://github.com/wangp/bower"
SRC_URI="https://github.com/wangp/bower/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

COMMON_DEPEND="app-crypt/gpgme:=
	sys-libs/ncurses:0="
DEPEND="${COMMON_DEPEND}
	>=dev-lang/mercury-11.07"
RDEPEND="${COMMON_DEPEND}
	net-mail/notmuch
	sys-apps/coreutils"

src_prepare() {
	default
	if has_version "sys-libs/ncurses:0[tinfo]" ; then
		echo "MLLIBS-bower += -ltinfow" >> src/Mercury.params || die
	fi
}

src_compile() {
	emake PARALLEL="--jobs $(makeopts_jobs) --no-strip --very-verbose"
}

src_install() {
	dobin bower
	dodoc AUTHORS NEWS README.md bower.conf.sample
}
