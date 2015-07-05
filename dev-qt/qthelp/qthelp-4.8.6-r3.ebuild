# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-qt/qthelp/qthelp-4.8.6-r3.ebuild,v 1.8 2015/07/05 21:13:59 klausman Exp $

EAPI=5

inherit qt4-build-multilib

DESCRIPTION="The Help module for the Qt toolkit"
SRC_URI+="
	compat? (
		http://download.qt.io/archive/qt/4.6/qt-assistant-qassistantclient-library-compat-src-4.6.3.tar.gz
		http://dev.gentoo.org/~pesa/distfiles/qt-assistant-compat-headers-4.7.tar.gz
	)"

if [[ ${QT4_BUILD_TYPE} == live ]]; then
	KEYWORDS="alpha arm ppc ppc64"
else
	KEYWORDS="alpha amd64 arm ~ia64 ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
fi

IUSE="compat doc"

DEPEND="
	~dev-qt/qtcore-${PV}[aqua=,debug=,${MULTILIB_USEDEP}]
	~dev-qt/qtgui-${PV}[aqua=,debug=,${MULTILIB_USEDEP}]
	~dev-qt/qtsql-${PV}[aqua=,debug=,sqlite,${MULTILIB_USEDEP}]
	compat? (
		~dev-qt/qtdbus-${PV}[aqua=,debug=,${MULTILIB_USEDEP}]
		>=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]
	)
"
RDEPEND="${DEPEND}"

QT4_TARGET_DIRECTORIES="
	tools/assistant/lib/fulltextsearch
	tools/assistant/lib
	tools/assistant/tools/qhelpgenerator
	tools/assistant/tools/qcollectiongenerator
	tools/assistant/tools/qhelpconverter
	tools/qdoc3"

pkg_setup() {
	use compat && QT4_TARGET_DIRECTORIES+="
		tools/assistant/compat
		tools/assistant/compat/lib"
}

src_unpack() {
	qt4-build-multilib_src_unpack

	# compat version
	# http://blog.qt.io/blog/2010/06/22/qt-assistant-compat-version-available-as-extra-source-package/
	if use compat; then
		mv "${WORKDIR}"/qt-assistant-qassistantclient-library-compat-version-4.6.3 "${S}"/tools/assistant/compat || die
		mv "${WORKDIR}"/QtAssistant "${S}"/include || die
		find "${S}"/tools/assistant/compat -type f -execdir chmod a-x '{}' + || die
	fi
}

src_prepare() {
	use compat && PATCHES+=(
		"${FILESDIR}/${PN}-4.8.6-compat-install.patch"
		"${FILESDIR}/${PN}-4.8.6-compat-syncqt.patch"
	)

	qt4-build-multilib_src_prepare

	# prevent rebuild of QtCore and QtXml (bug 348034)
	sed -i -e '/^sub-qdoc3\.depends/d' doc/doc.pri || die
}

multilib_src_configure() {
	local myconf=(
		-system-libpng -system-libjpeg -system-zlib
		-no-sql-mysql -no-sql-psql -no-sql-ibase -no-sql-sqlite2 -no-sql-odbc
		-sm -xshape -xsync -xcursor -xfixes -xrandr -xrender -mitshm -xinput -xkb
		-no-multimedia -no-opengl -no-phonon -no-qt3support -no-svg -no-webkit -no-xmlpatterns
		-no-nas-sound -no-cups -no-nis -fontconfig
	)
	qt4_multilib_src_configure
}

multilib_src_compile() {
	qt4_multilib_src_compile

	# release tarballs are shipped with prebuilt docs
	if [[ ${QT4_BUILD_TYPE} == live ]] && multilib_is_native_abi; then
		# qhelpgenerator needs libQtHelp.so.4
		export LD_LIBRARY_PATH=${BUILD_DIR}/lib
		export DYLD_LIBRARY_PATH=${BUILD_DIR}/lib:${BUILD_DIR}/lib/QtHelp.framework
		emake docs
	fi
}

multilib_src_install() {
	qt4_multilib_src_install

	if multilib_is_native_abi; then
		emake INSTALL_ROOT="${D}" install_qchdocs
		use doc && emake INSTALL_ROOT="${D}" install_htmldocs

		# do not compress .qch files
		docompress -x "${QT4_DOCDIR#${EPREFIX}}"/qch
	fi
}

multilib_src_install_all() {
	qt4_multilib_src_install_all

	if use compat; then
		insinto "${QT4_DATADIR#${EPREFIX}}"/mkspecs/features
		doins tools/assistant/compat/features/assistant.prf
	fi
}
