# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PLOCALES="en fi sv da uk"
PLOCALE_BACKUP="en"
inherit qt4-r2 qmake-utils virtualx vcs-snapshot

COMMIT_ID="cd0652c52f86f6284b793f26e5362bc8fb8a7118"
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
		dev-qt/qtgui:4[debug?]
		dev-qt/qt-mobility[multimedia]
		dev-qt/qtmultimedia:4
		media-libs/opus"

DEPEND="${RDEPEND}
	dev-qt/qttest:4
		sys-devel/gdb:0
	doc? ( app-doc/doxygen[dot] )
	test? ( dev-libs/libgcrypt:0
		${VIRTUALX_DEPEND} )
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
	virtx test_suite
}

src_install() {
	emake install INSTALL_ROOT="${D}" DESTDIR="${D}"
	use doc && dodoc -r doc/doxygen.generated/html/
}

# virtualx requires a command that returns number, and does not just die:
test_suite() {
	cd test || return -1
	echo qmake
	"$(qt4_get_bindir)"/qmake || return -2
	emake
	# test suite will create files under $HOME, set $HOME to point to
	# safe location, ideas stolen from
	# eclass/distutils-r1.eclass func distutils_install_for_testing
	BACKUP_HOME=$HOME
	export HOME=${BUILD_DIR}/tmp
	mkdir -p $HOME || true
	./testca
	result=$?
	export HOME=$BACKUP_HOME
	if [ $result != "0" ]; then
		echo "test suite failed with error code " `echo $result`
		return $result
	else
		return 0
	fi
}
