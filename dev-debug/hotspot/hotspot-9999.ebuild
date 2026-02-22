# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=6.8.1
KFMIN=6.18.0

inherit ecm xdg

DESCRIPTION="Linux perf GUI for performance analysis"
HOMEPAGE="https://github.com/KDAB/hotspot"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/KDAB/hotspot"
	inherit git-r3
elif [[ ${PV} == *_p* ]] ; then
	HOTSPOT_COMMIT="b61451d827dd23e35c5f611e3626226a119dfa48"
	PERFPARSER_COMMIT="65472541f74da213583535c8bb4fea831e875109"
	PREFIXTICKLABELS_COMMIT="7cd6d5a04cf3747cc9327efdbcbf43620efaa0c1"
	SRC_URI="
		https://github.com/KDAB/hotspot/archive/${HOTSPOT_COMMIT}.tar.gz
			-> ${PN}-${HOTSPOT_COMMIT}.gh.tar.gz
		https://github.com/KDAB/perfparser/archive/${PERFPARSER_COMMIT}.tar.gz
			-> perfparser-${PERFPARSER_COMMIT}.gh.tar.gz
		https://github.com/koenpoppe/PrefixTickLabels/archive/${PREFIXTICKLABELS_COMMIT}.tar.gz
			-> PrefixTickLabels-${PREFIXTICKLABELS_COMMIT}.gh.tar.gz
	"
	S="${WORKDIR}"/${PN}-${HOTSPOT_COMMIT}
else
	SRC_URI="
		https://github.com/KDAB/hotspot/releases/download/v${PV}/${PN}-v${PV}.tar.gz
		https://github.com/KDAB/hotspot/releases/download/v${PV}/${PN}-perfparser-v${PV}.tar.gz
			-> ${PN}-v${PV}-perfparser.tar.gz
		https://github.com/KDAB/hotspot/releases/download/v${PV}/${PN}-PrefixTickLabels-v${PV}.tar.gz
			-> ${PN}-v${PV}-PrefixTickLabels.tar.gz
	"
	S="${WORKDIR}"/${PN}
fi

# hotspot itself is GPL-2 or GPL-3
# bundled perfparser is GPL-3
# bundled PrefixTickLabels is GPL-3
LICENSE="|| ( GPL-2 GPL-3 ) GPL-3"
SLOT="0"
IUSE="debuginfod"
if [[ ${PV} != 9999 ]] ; then
	KEYWORDS="~amd64"
fi

DEPEND="
	app-arch/zstd:=
	dev-libs/elfutils[debuginfod?]
	dev-libs/qcustomplot
	>=dev-qt/qtbase-${QTMIN}:6=[network,widgets]
	>=dev-qt/qtsvg-${QTMIN}:6
	gui-libs/kddockwidgets:=
	>=kde-frameworks/karchive-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kitemviews-${KFMIN}:6
	>=kde-frameworks/kitemmodels-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/kparts-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
	>=kde-frameworks/solid-${KFMIN}:6
	>=kde-frameworks/syntax-highlighting-${KFMIN}:6
	>=kde-frameworks/threadweaver-${KFMIN}:6
	media-gfx/kgraphviewer
	sys-devel/gettext
"
RDEPEND="
	${DEPEND}
	dev-util/perf
	sys-devel/binutils:*
"

PATCHES=(
	"${FILESDIR}"/${PN}-odr.patch
)

src_unpack() {
	if [[ ${PV} == 9999 ]] ; then
		git-r3_src_unpack
	elif [[ ${PV} == *_p* ]] ; then
		unpack ${PN}-${HOTSPOT_COMMIT}.gh.tar.gz
		tar -xf "${DISTDIR}"/perfparser-${PERFPARSER_COMMIT}.gh.tar.gz --strip-components=1 \
			-C "${S}"/3rdparty/perfparser || die
		tar -xf "${DISTDIR}"/PrefixTickLabels-${PREFIXTICKLABELS_COMMIT}.gh.tar.gz --strip-components=1 \
			-C "${S}"/3rdparty/PrefixTickLabels || die
	else
		unpack ${PN}-v${PV}.tar.gz
		tar -xf "${DISTDIR}"/${PN}-v${PV}-perfparser.tar.gz --strip-components=1 \
			-C "${S}"/3rdparty/perfparser || die
		tar -xf "${DISTDIR}"/${PN}-v${PV}-PrefixTickLabels.tar.gz --strip-components=1 \
			-C "${S}"/3rdparty/PrefixTickLabels || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DQT6_BUILD=true
	)

	if ! use debuginfod; then
		mycmakeargs+=(
			-DHAVE_DWFL_GET_DEBUGINFOD_CLIENT_SYMBOL="no"
			-DHAVE_DEBUGINFOD_SET_USER_DATA="no"
		)
	fi

	ecm_src_configure
}

src_test() {
	CMAKE_SKIP_TESTS=(
		# Complains about {d,rustc}_demangle missing, but may fail
		# for other reasons too.
		tst_perfparser
	)

	ecm_src_test
}
