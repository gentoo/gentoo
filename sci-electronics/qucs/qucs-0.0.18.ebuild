# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Quite Universal Circuit Simulator in Qt4"
HOMEPAGE="http://qucs.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="dev-qt/qtcore:4[qt3support]
	dev-qt/qtgui:4[qt3support]
	dev-qt/qtscript:4
	dev-qt/qtsvg:4
	dev-qt/qt3support:4
	x11-libs/libX11:0="
DEPEND="${RDEPEND}"

src_prepare() {
	default

	# oh my, they strip -g out of C*FLAGS and force -s into LDFLAGS
	# note: edit .ac first, then generated files, so that the latter
	# have newer timestamp and not trigger regen
	sed -i \
		-e 's/C.*FLAGS.*sed.*-g.*$/:/' \
		-e 's/C.*FLAGS.*-O0.*$/:/' \
		-e 's/LDFLAGS.*-s.*$/:/' \
		configure.ac asco/configure.ac qucs-core/configure.ac \
		configure asco/configure qucs-core/configure \
		|| die "C*FLAGS and LDFLAGS sanitization sed failed"
}

src_configure() {
	local myconf=(
		# enables asserts and debug codepaths
		$(use_enable debug)

		# avoid automagic dep
		# TODO: add support for it
		--disable-mpi
	)

	# automagic default on clang++
	tc-export CXX

	# the package doesn't use pkg-config on Linux, only on Darwin
	# very smart of upstream...
	append-ldflags $( $(tc-getPKG_CONFIG) --libs-only-L \
			QtCore QtGui QtScript QtSvg QtXml Qt3Support )

	econf "${myconf[@]}"
}

pkg_postinst() {
	if ! has_version 'sci-electronics/freehdl'; then
		elog "If you would like to be able to run digital simulations, please install:"
		elog "  sci-electronics/freehdl"
	fi
}
