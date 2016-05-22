# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PLOCALES="en fi sv da uk"
PLOCALE_BACKUP="en"
inherit qmake-utils virtualx vcs-snapshot l10n

COMMIT_ID="cd0652c52f86f6284b793f26e5362bc8fb8a7118"
DESCRIPTION="Program for displaying classified advertisement items"
HOMEPAGE="http://katiska.org/classified-ads/"
SRC_URI="https://github.com/operatornormal/classified-ads/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz \
	https://github.com/operatornormal/classified-ads/blob/graphics/preprocessed.tar.gz?raw=true \
		-> classified-ads-graphics-${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="doc test"

RDEPEND="dev-libs/openssl:0
		>=net-libs/libnatpmp-20130911
		<=net-libs/libnatpmp-20140401-r1
		>=net-libs/miniupnpc-1.8
		sys-apps/file
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5[ssl]
		dev-qt/qtwidgets:5
		dev-qt/qtsql:5[sqlite]
		dev-qt/qtmultimedia:5[widgets]
		dev-qt/qt-mobility[multimedia]
		dev-qt/qtprintsupport:5
		media-libs/opus
		virtual/libintl"

DEPEND="${RDEPEND}
	sys-devel/gettext
	doc? ( app-doc/doxygen[dot] )
	test? ( dev-libs/libgcrypt:0
		dev-qt/qttest:5
		sys-devel/gdb:0 )"

src_prepare() {
	# preprocessed graphics are unpacked into wrong directory
	# so lets move them into correct location:
	mv ../classified-ads-graphics-${PV}/* ui/ || die
	# possible patches
	eapply_user
}

src_configure() {
	eqmake5
	if use test; then
		cd test || die
		eqmake5
	fi
}

src_compile() {
	emake
	if use doc; then
		pushd doc >> /dev/null || die
		doxygen || die
		popd >> /dev/null || die
	fi
	if use test; then
		pushd test >> /dev/null || die
		emake
		popd >> /dev/null || die
	fi
}

src_test() {
	# testca will return 0 if all unit tests pass
	virtx ./test/testca
}

src_install() {
	emake install INSTALL_ROOT="${D}" DESTDIR="${D}"
	use doc && dodoc -r doc/doxygen.generated/html/
}
