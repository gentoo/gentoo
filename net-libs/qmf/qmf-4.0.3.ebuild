# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/qmf/qmf-4.0.3.ebuild,v 1.7 2015/06/14 23:29:01 pesa Exp $

EAPI=5

inherit qt4-r2

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI=(
		"git://code.qt.io/qt-labs/messagingframework.git"
		"https://code.qt.io/git/qt-labs/messagingframework.git"
	)
else
	SRC_URI="http://dev.gentoo.org/~pesa/distfiles/${P}.tar.gz"
	S=${WORKDIR}/qt-labs-messagingframework
fi

DESCRIPTION="The Qt Messaging Framework"
HOMEPAGE="https://code.qt.io/cgit/qt-labs/messagingframework.git/"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="debug doc examples icu test zlib"

RDEPEND="
	>=dev-qt/qtcore-4.8:4
	>=dev-qt/qtgui-4.8:4
	>=dev-qt/qtsql-4.8:4
	examples? ( >=dev-qt/qtwebkit-4.8:4 )
	icu? ( dev-libs/icu:= )
	zlib? ( sys-libs/zlib )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( >=dev-qt/qttest-4.8:4 )
"

DOCS=( CHANGES )
PATCHES=(
	"${FILESDIR}/${PN}-4.0.2-tests.patch"
)

src_prepare() {
	qt4-r2_src_prepare

	sed -i -e '/SUBDIRS.*=/s/benchmarks//' messagingframework.pro || die

	if ! use examples; then
		sed -i -e '/SUBDIRS.*=/s/examples//' messagingframework.pro || die
	fi
	if ! use test; then
		sed -i -e '/SUBDIRS.*=/s/tests//' messagingframework.pro || die
	fi

	# disable automagic deps
	if ! use icu; then
		sed -i -e 's/packagesExist(icu-uc)/false:&/' \
			src/libraries/qmfclient/qmfclient.pro || die
	fi
	if ! use zlib; then
		sed -i -e 's/packagesExist(zlib)/false:&/' \
			src/plugins/messageservices/imap/imap.pro || die
	fi

	# fix libdir
	find "${S}" -name '*.pro' -type f -print0 | xargs -0 \
		sed -i -re "s:/lib(/|$):/$(get_libdir)\1:" || die
	sed -i -e "s:/lib/:/$(get_libdir)/:" \
		src/libraries/qmfclient/support/qmailnamespace.cpp || die
}

src_configure() {
	eqmake4 QMF_INSTALL_ROOT="${EPREFIX}/usr"
}

src_test() {
	cd "${S}"/tests

	export QMF_DATA=${T}
	local fail=false test=
	for test in tst_*; do
		# skip test that requires messageserver to be running
		[[ ${test} == tst_qmailstorageaction ]] && continue

		if ! LC_ALL=C ./${test}/${test}; then
			eerror "${test#tst_} test failed!"
			fail=true
		fi
		echo
	done

	${fail} && die "some tests have failed!"
}

src_install() {
	qt4-r2_src_install

	if use doc; then
		emake docs

		dodoc -r doc/html
		dodoc doc/html/qmf.qch
		docompress -x /usr/share/doc/${PF}/qmf.qch
	fi
}
