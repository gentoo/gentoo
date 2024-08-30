# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=signon-plugin-oauth2
MY_PV=VERSION_${PV}
MY_P=${MY_PN}-${MY_PV}
inherit qmake-utils

if [[ ${PV} = *9999* ]] ; then
	EGIT_REPO_URI="https://gitlab.com/nicolasfella/${MY_PN}.git/"
	EGIT_BRANCH="qt6"
	inherit git-r3
else
	COMMIT=d759439066f0a34e5ad352ebab0b3bb2790d429e
	if [[ -n ${COMMIT} ]] ; then
		SRC_URI="https://gitlab.com/accounts-sso/${MY_PN}/-/archive/${COMMIT}/${MY_PN}-${COMMIT}.tar.bz2 -> ${P}.tar.bz2"
		S="${WORKDIR}/${MY_PN}-${COMMIT}"
	else
		SRC_URI="https://gitlab.com/accounts-sso/${MY_PN}/-/archive/${MY_PV}/${MY_P}.tar.bz2 -> ${P}.tar.bz2"
		S="${WORKDIR}/${MY_P}"
	fi
	KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"
fi

DESCRIPTION="OAuth2 plugin for Signon daemon"
HOMEPAGE="https://gitlab.com/accounts-sso/signon-plugin-oauth2"

LICENSE="LGPL-2.1"
SLOT="0"
# TODO: drop USE=qt5 and just have USE=qt6 to control which qt?
IUSE="+qt5 qt6 test"
REQUIRED_USE="|| ( qt5 qt6 )"
RESTRICT="!test? ( test )"

RDEPEND="
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtnetwork:5[ssl]
	)
	qt6? ( dev-qt/qtbase:6[network,ssl] )
	>=net-libs/signond-8.61-r100[qt5=,qt6=]
"
DEPEND="
	${RDEPEND}
	test? (
		qt5? ( dev-qt/qttest:5 )
	)
"

PATCHES=(
	"${FILESDIR}"/0001-Port-QSignalSpys-to-PMF-syntax.patch
	"${FILESDIR}"/0002-Port-to-new-connection-syntax.patch
	"${FILESDIR}"/0003-Port-away-from-deprecated-error-signal.patch
	"${FILESDIR}"/0004-Port-away-from-deprecated-qrand.patch
	"${FILESDIR}"/0005-Fix-string-concatenation-in-Qt6.patch
	"${FILESDIR}"/0006-Port-away-from-deprecated-QRegExp.patch
	"${FILESDIR}"/0007-Build-with-C-17.patch
	"${FILESDIR}"/0008-Use-correct-signon-in-example.patch
	"${FILESDIR}"/0009-Port-away-from-deprecated-QString-SplitBehavior.patch
	"${FILESDIR}"/0010-Port-away-from-deprecated-QList-toSet.patch
	# downstream patches
	"${FILESDIR}/${PN}-0.24-dont-install-tests.patch"
	"${FILESDIR}/${PN}-0.25-pkgconfig-libdir.patch"
	"${FILESDIR}/${PN}-0.25-drop-fno-rtti.patch"
)

src_prepare() {
	default
	sed -i "s|@LIBDIR@|$(get_libdir)|g" src/signon-oauth2plugin.pc || die
}

src_configure() {
	local myqmakeargs=(
		LIBDIR=/usr/$(get_libdir)
	)
	use test || myqmakeargs+=( CONFIG+=nomake_tests )

	if use qt6 ; then
		eqmake6 "${myqmakeargs[@]}"
	else
		eqmake5 "${myqmakeargs[@]}"
	fi
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}
