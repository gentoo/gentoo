# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

DESCRIPTION="Nextcloud themed desktop client"
HOMEPAGE="https://github.com/nextcloud/client_theming"
SRC_URI="http://download.owncloud.com/desktop/stable/owncloudclient-${PV}.tar.xz
	https://github.com/nextcloud/client_theming/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="CC-BY-3.0 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc dolphin nautilus samba +sftp test"

COMMON_DEPEND=">=dev-db/sqlite-3.4:3
	dev-libs/qtkeychain[qt5]
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtquickcontrols:5
	dev-qt/qtsql:5
	dev-qt/qtwebkit:5[printsupport]
	sys-fs/inotify-tools
	virtual/libiconv
	dolphin? (
		kde-frameworks/kcoreaddons:5
		kde-frameworks/kio:5
	)
	nautilus? ( dev-python/nautilus-python )
	samba? ( >=net-fs/samba-3.5 )
	sftp? ( >=net-libs/libssh-0.5 )
"
RDEPEND="${COMMON_DEPEND}
	!net-misc/ocsync
	!net-misc/owncloud-client
"
DEPEND="${COMMON_DEPEND}
	dev-qt/linguist-tools:5
	doc? (
		dev-python/sphinx
		dev-texlive/texlive-latexextra
		virtual/latex-base
	)
	dolphin? ( kde-frameworks/extra-cmake-modules )
	test? (
		dev-util/cmocka
		dev-qt/qttest:5
	)
"

S=${WORKDIR}/client_theming-${PV}

src_unpack() {
	default

	rmdir "${S}"/client || die
	mv "${WORKDIR}"/owncloudclient-${PV} "${S}"/client \
		|| die
}

src_prepare() {
	CMAKE_USE_DIR="${S}"/client
	# Keep tests in ${T}
	sed -i -e "s#\"/tmp#\"${T}#g" client/test/test*.cpp || die "sed failed"

	if ! use nautilus; then
		pushd client/shell_integration > /dev/null || die
		cmake_comment_add_subdirectory nautilus
		popd > /dev/null || die
	fi

	default
}

src_configure() {
	local mycmakeargs=(
		-DSYSCONF_INSTALL_DIR="${EPREFIX}"/etc
		-DCMAKE_INSTALL_DOCDIR=/usr/share/doc/${PF}
		-DWITH_ICONV=ON
		-DWITH_DOC=$(usex doc)
		-DCMAKE_DISABLE_FIND_PACKAGE_KF5=$(usex !dolphin)
		-DBUILD_WITH_QT4=OFF
		-DCMAKE_DISABLE_FIND_PACKAGE_Libsmbclient=$(usex !samba)
		-DCMAKE_DISABLE_FIND_PACKAGE_LibSSH=$(usex !sftp)
		-DUNIT_TESTING=$(usex test)
		-DOEM_THEME_DIR="${S}"/nextcloudtheme
	)

	cmake-utils_src_configure
}

pkg_postinst() {
	if ! use doc ; then
		elog "Documentation and man pages not installed"
		elog "Enable doc USE-flag to generate them"
	fi
}
