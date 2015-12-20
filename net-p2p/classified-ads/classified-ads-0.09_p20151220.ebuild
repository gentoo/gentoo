# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PLOCALES="en fi sv da"
PLOCALE_BACKUP="en"
inherit qt4-r2 vcs-snapshot qmake-utils

COMMIT_ID="c761d4e7124ebe9c76bc1529b27fe9c0aa1c2078"
DESCRIPTION="Program for displaying classified advertisement items"
HOMEPAGE="http://katiska.org/classified-ads/"
SRC_URI="https://github.com/operatornormal/classified-ads/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz \
	https://github.com/operatornormal/classified-ads/blob/graphics/preprocessed.tar.gz?raw=true \
		-> classified-ads-graphics-${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="debug doc test"

RDEPEND="dev-libs/openssl:0
		dev-libs/qjson
		>=net-libs/libnatpmp-20130911
		<=net-libs/libnatpmp-20140401-r1
		>=net-libs/miniupnpc-1.8
		sys-apps/file
		sys-devel/gettext
		dev-qt/qtcore:4[ssl]
		dev-qt/qtsql:4[sqlite]
		dev-qt/qtgui:4[debug?]"

DEPEND="${RDEPEND}
	dev-qt/qttest:4
		sys-devel/gdb:0
	doc? ( app-doc/doxygen[dot] )
	test? ( dev-libs/libgcrypt:0 )
	"

src_prepare() {
	# preprocessed graphics are unpacked into wrong directory
	# so lets move them into correct location:
	mv ../classified-ads-graphics-${PV}/* ui/ || die
	# then just run qmake
	qt4-r2_src_prepare
}

src_compile() {
	qt4-r2_src_compile
	if use doc; then
		cd doc || die
		doxygen || die
	fi
}

src_test() {
	cd test || die "test suite missing"
	$(qt4_get_bindir)/qmake || die "test suite configure failed"
	emake

	if [ -e $HOME/.classified_ads/sqlite_db ]; then
		mv $HOME/.classified_ads/sqlite_db $HOME/.classified_ads/sqlite_db.backup \
			|| die "datafile backup failed"
	fi
	./testca
	result=$?
	rm $HOME/.classified_ads/sqlite_db || true

	if [ -e $HOME/.classified_ads/sqlite_db.backup ]; then
		mv $HOME/.classified_ads/sqlite_db.backup $HOME/.classified_ads/sqlite_db \
			|| die "datafile restore failed"
	fi

	if [ $result != "0" ]; then
		die "test failed with code $result"
	fi

	return $result
}

src_install() {
	emake install INSTALL_ROOT="${D}" DESTDIR="${D}"
	use doc && dodoc -r doc/doxygen.generated/html/
}
