# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

DESCRIPTION="Synchronize files from ownCloud Server with your computer"
HOMEPAGE="http://owncloud.org/"
SRC_URI="http://download.owncloud.com/desktop/stable/${P/-}.tar.xz"

LICENSE="CC-BY-3.0 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc dolphin nautilus samba +sftp test qt4 +qt5"

REQUIRED_USE="^^ ( qt4 qt5 )"

RDEPEND=">=dev-db/sqlite-3.4:3
	sys-fs/inotify-tools
	virtual/libiconv
	dolphin? (
		>=kde-frameworks/kcoreaddons-5.16:5
		>=kde-frameworks/kio-5.16:5 )
	nautilus? ( dev-python/nautilus-python )
	qt4? (
		dev-libs/qtkeychain[qt4]
		dev-qt/qtcore:4
		dev-qt/qtdbus:4
		dev-qt/qtgui:4
		dev-qt/qtsql:4
		dev-qt/qtwebkit:4
		net-libs/neon[ssl]
	)
	qt5? (
		dev-libs/qtkeychain[qt5]
		dev-qt/qtconcurrent:5
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		>=dev-qt/qtnetwork-5.4:5
		dev-qt/qtgui:5
		dev-qt/qtquickcontrols:5
		dev-qt/qtsql:5
		dev-qt/qtwebkit:5[printsupport]
	)
	samba? ( >=net-fs/samba-3.5 )
	sftp? ( >=net-libs/libssh-0.5 )
	!net-misc/ocsync"
DEPEND="${RDEPEND}
	doc? (
		dev-python/sphinx
		dev-texlive/texlive-latexextra
		virtual/latex-base
	)
	qt5? ( dev-qt/linguist-tools:5 )
	test? (
		dev-util/cmocka
		qt4? ( dev-qt/qttest:4 )
		qt5? ( dev-qt/qttest:5 )
	)"

S=${WORKDIR}/${P/-}

src_prepare() {
	# Keep tests in ${T}
	sed -i -e "s#\"/tmp#\"${T}#g" test/test*.cpp || die "sed failed"

	use nautilus || sed -i -e "s/add_subdirectory(nautilus)//" \
		shell_integration/CMakeLists.txt || die "sed failed"

	default
}

src_configure() {
	local mycmakeargs=(
		-DSYSCONF_INSTALL_DIR="${EPREFIX}"/etc
		-DCMAKE_INSTALL_DOCDIR=/usr/share/doc/${PF}
		-DWITH_ICONV=ON
		-DWITH_DOC=$(usex doc)
		-DCMAKE_DISABLE_FIND_PACKAGE_KF5=$(usex !dolphin)
		-DBUILD_WITH_QT4=$(usex qt4)
		-DCMAKE_DISABLE_FIND_PACKAGE_Libsmbclient=$(usex !samba)
		-DCMAKE_DISABLE_FIND_PACKAGE_LibSSH=$(usex !sftp)
		-DUSE_UNIT_TESTING=$(usex test)
	)

	cmake-utils_src_configure
}

src_test() {
	# 1 test needs an existing ${HOME}/.config directory
	mkdir "${T}"/.config
	export HOME="${T}"
	cmake-utils_src_test
}

pkg_postinst() {
	if ! use doc ; then
		elog "Documentation and man pages not installed"
		elog "Enable doc USE-flag to generate them"
	fi
}
