# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils

if [[ ${PV} = *9999* ]] ; then
	EGIT_REPO_URI="https://gitlab.com/nicolasfella/signond.git/"
	EGIT_BRANCH="qt6"
	inherit git-r3
else
	SRC_URI="https://gitlab.com/accounts-sso/${PN}/-/archive/VERSION_${PV}/${PN}-VERSION_${PV}.tar.bz2 -> ${P}.tar.bz2"
	S="${WORKDIR}/${PN}-VERSION_${PV}"
	KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv ~x86"
fi

DESCRIPTION="Signon daemon for libaccounts-glib"
HOMEPAGE="https://gitlab.com/accounts-sso"

LICENSE="LGPL-2.1"
SLOT="0"
# The qt5/qt6 situation is complicated:
# https://gitlab.com/accounts-sso/signon-plugin-oauth2/-/merge_requests/28#note_1689621252
IUSE="doc test"

# tests are brittle; they all pass when stars align, bug 727666
RESTRICT="test !test? ( test )"

RDEPEND="
	dev-qt/qtbase:6[dbus,gui,network,sql]
	net-libs/libproxy
"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? (
		app-text/doxygen[dot]
		dev-qt/qttools:6[assistant]
	)
"

PATCHES=(
	"${FILESDIR}"/0001-Don-t-forward-declare-QStringList.patch
	"${FILESDIR}"/0002-Remove-usage-of-Q_EXTERN_C.patch
	"${FILESDIR}"/0003-Port-from-QProcess-pid-to-processId.patch
	"${FILESDIR}"/0004-Port-away-from-deprecated-QString-SplitBehavior.patch
	"${FILESDIR}"/0005-Port-away-from-QtContainer-toSet.patch
	"${FILESDIR}"/0006-Port-away-from-deprecated-QMap-unite.patch
	"${FILESDIR}"/0008-Use-return-instead-of-reference-for-DBus-output-para.patch
	"${FILESDIR}"/0009-Adjust-buildsystem-to-include-correct-Qt-Major-versi.patch
	"${FILESDIR}"/0010-Fix-plugin-datastream-in-Qt6.patch
	"${FILESDIR}"/0011-Port-away-from-deprecated-QProcess-signal.patch
	"${FILESDIR}/${PN}-8.60-buildsystem.patch"
	"${FILESDIR}/${PN}-8.60-unused-dep.patch" # bug 727346
	"${FILESDIR}/${PN}-8.61-consistent-paths.patch" # bug 701142
)

src_prepare() {
	default

	sed -e "/QHG_LOCATION/s|qhelpgenerator|$(qt6_get_libexecdir)/&|" \
		-i {lib/plugins/,lib/SignOn/,}doc/doxy.conf || die

	# install docs to correct location
	sed -e "s|share/doc/\$\${PROJECT_NAME}|share/doc/${PF}|" \
		-i doc/doc.pri || die
	sed -e "/^documentation.path = /c\documentation.path = \$\${INSTALL_PREFIX}/share/doc/${PF}/\$\${TARGET}/" \
		-i lib/plugins/doc/doc.pri || die
	sed -e "/^documentation.path = /c\documentation.path = \$\${INSTALL_PREFIX}/share/doc/${PF}/libsignon-qt/" \
		-i lib/SignOn/doc/doc.pri || die

	use doc || sed -e "/include(\s*doc\/doc.pri\s*)/d" \
		-i signon.pro lib/SignOn/SignOn.pro lib/plugins/plugins.pro || die

	use test || sed -e '/^SUBDIRS/s/tests//' \
		-i signon.pro || die "couldn't disable tests"
}

src_configure() {
	local myqmakeargs=(
		PREFIX="${EPREFIX}"/usr
		LIBDIR=$(get_libdir)
	)
	eqmake6 "${myqmakeargs[@]}"
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]] && \
		! has_version "kde-apps/signon-kwallet-extension:*"; then
		ewarn "Without kde-apps/signon-kwallet-extension installed, passwords"
		ewarn "will be saved in plaintext!"
	fi
}
