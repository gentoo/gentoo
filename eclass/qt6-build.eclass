# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: qt6-build.eclass
# @MAINTAINER:
# qt@gentoo.org
# @SUPPORTED_EAPIS: 8
# @BLURB: Eclass for Qt6 split ebuilds.
# @DESCRIPTION:
# This eclass contains various functions that are used when building Qt6.
# Requires EAPI 8.

if [[ ${CATEGORY} != dev-qt ]]; then
	die "qt6-build.eclass is only to be used for building Qt 6"
fi

case ${EAPI} in
	8)	: ;;
	*)	die "qt6-build.eclass: unsupported EAPI=${EAPI:-0}" ;;
esac

# @ECLASS_VARIABLE: QT6_MODULE
# @PRE_INHERIT
# @DESCRIPTION:
# The upstream name of the module this package belongs to. Used for
# SRC_URI and EGIT_REPO_URI. Must be set before inheriting the eclass.
: ${QT6_MODULE:=${PN}}

# @ECLASS_VARIABLE: VIRTUALX_REQUIRED
# @DESCRIPTION:
# For proper description see virtualx.eclass man page.
# Here we redefine default value to be manual, if your package needs virtualx
# for tests you should proceed with setting VIRTUALX_REQUIRED=test.
: ${VIRTUALX_REQUIRED:=manual}

inherit cmake virtualx

HOMEPAGE="https://www.qt.io/"
LICENSE="|| ( GPL-2 GPL-3 LGPL-3 ) FDL-1.3"
SLOT=6/$(ver_cut 1-2)

QT6_MINOR_VERSION=$(ver_cut 2)
readonly QT6_MINOR_VERSION

case ${PV} in
	6.9999)
		# git dev branch
		QT6_BUILD_TYPE="live"
		EGIT_BRANCH="dev"
		;;
	6.?.9999|6.??.9999)
		# git stable branch
		QT6_BUILD_TYPE="live"
		EGIT_BRANCH=${PV%.9999}
		;;
	*_alpha*|*_beta*|*_rc*)
		# development release
		QT6_BUILD_TYPE="release"
		MY_P=${QT6_MODULE}-everywhere-src-${PV/_/-}
		SRC_URI="https://download.qt.io/development_releases/qt/${PV%.*}/${PV/_/-}/submodules/${MY_P}.tar.xz"
		S=${WORKDIR}/${MY_P}
		;;
	*)
		# official stable release
		QT6_BUILD_TYPE="release"
		MY_P=${QT6_MODULE}-everywhere-src-${PV}
		SRC_URI="https://download.qt.io/official_releases/qt/${PV%.*}/${PV}/submodules/${MY_P}.tar.xz"
		S=${WORKDIR}/${MY_P}
		;;
esac
readonly QT6_BUILD_TYPE

EGIT_REPO_URI=(
	"https://code.qt.io/qt/${QT6_MODULE}.git"
	"https://github.com/qt/${QT6_MODULE}.git"
)
[[ ${QT6_BUILD_TYPE} == live ]] && inherit git-r3

# @ECLASS_VARIABLE: QT6_BUILD_DIR
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# Build directory for out-of-source builds.
: ${QT6_BUILD_DIR:=${S}_build}

IUSE="debug test"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	RESTRICT="test" # bug 457182
else
	RESTRICT="!test? ( test )"
fi

BDEPEND="
	dev-lang/perl
	virtual/pkgconfig
"
# TODO: Tests have not been split from qtbase.
#if [[ ${PN} != qttest ]]; then
#	DEPEND+=" test? ( ~dev-qt/qttest-${PV} )"
#fi

EXPORT_FUNCTIONS src_prepare src_configure

######  Phase functions  ######

# @FUNCTION: qt6-build_src_prepare
# @DESCRIPTION:
# Prepares the environment and patches the sources if necessary.
qt6-build_src_prepare() {
	qt6_prepare_env

	cmake_src_prepare
}

# @FUNCTION: qt6-build_src_configure
# @DESCRIPTION:
# Configures sources.
qt6-build_src_configure() {
	cmake_src_configure
}

######  Public helpers  ######

# @FUNCTION: qt_feature
# @USAGE: <flag> [feature]
# @DESCRIPTION:
# <flag> is the name of a flag in IUSE.
qt_feature() {
	[[ $# -ge 1 ]] || die "${FUNCNAME}() requires at least one argument"
	echo "-DQT_FEATURE_${2:-$1}=$(usex $1 ON OFF)"
}

######  Internal functions  ######

# @FUNCTION: qt6_prepare_env
# @INTERNAL
# @DESCRIPTION:
# Prepares the environment for building Qt.
qt6_prepare_env() {
	# setup installation directories
	# note: keep paths in sync with qmake-utils.eclass
	QT6_PREFIX=${EPREFIX}/usr
	QT6_HEADERDIR=${QT6_PREFIX}/include/qt6
	QT6_LIBDIR=${QT6_PREFIX}/$(get_libdir)
	QT6_ARCHDATADIR=${QT6_PREFIX}/$(get_libdir)/qt6
	QT6_BINDIR=${QT6_ARCHDATADIR}/bin
	QT6_PLUGINDIR=${QT6_ARCHDATADIR}/plugins
	QT6_LIBEXECDIR=${QT6_ARCHDATADIR}/libexec
	QT6_IMPORTDIR=${QT6_ARCHDATADIR}/imports
	QT6_QMLDIR=${QT6_ARCHDATADIR}/qml
	QT6_DATADIR=${QT6_PREFIX}/share/qt6
	QT6_DOCDIR=${QT6_PREFIX}/share/qt6-doc
	QT6_TRANSLATIONDIR=${QT6_DATADIR}/translations
	QT6_EXAMPLESDIR=${QT6_DATADIR}/examples
	QT6_TESTSDIR=${QT6_DATADIR}/tests
	QT6_SYSCONFDIR=${EPREFIX}/etc/xdg
	readonly QT6_PREFIX QT6_HEADERDIR QT6_LIBDIR QT6_ARCHDATADIR \
		QT6_BINDIR QT6_PLUGINDIR QT6_LIBEXECDIR QT6_IMPORTDIR \
		QT6_QMLDIR QT6_DATADIR QT6_DOCDIR QT6_TRANSLATIONDIR \
		QT6_EXAMPLESDIR QT6_TESTSDIR QT6_SYSCONFDIR
}
