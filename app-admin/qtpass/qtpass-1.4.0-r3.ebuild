# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/annejan.asc
inherit desktop qmake-utils verify-sig

DESCRIPTION="Multi-platform GUI for pass, the standard unix password manager"
HOMEPAGE="https://qtpass.org https://github.com/IJHack/qtpass"
SRC_URI="
	https://github.com/IJHack/QtPass/releases/download/v${PV}/QtPass-${PV}.tar.gz
	verify-sig? ( https://github.com/IJHack/QtPass/releases/download/v${PV}/QtPass-${PV}.tar.gz.asc )
"
S="${WORKDIR}/QtPass-${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	|| (
		app-admin/pass
		app-admin/gopass
	)
	dev-qt/qtbase:6[gui,network,widgets]
	net-misc/x11-ssh-askpass
"
DEPEND="
	${RDEPEND}
	dev-qt/qtsvg:6
"
BDEPEND="
	dev-qt/qttools:6[linguist]
	verify-sig? ( sec-keys/openpgp-keys-annejan )
"

DOCS=( {CHANGELOG,CONTRIBUTING,FAQ,README}.md )

PATCHES=(
	"${FILESDIR}"/${P}-qt-6.8-buildfix.patch
	"${FILESDIR}"/${P}-qt-6.8-profiles.patch
)

src_prepare() {
	default

	if ! use test ; then
		sed -i '/SUBDIRS += src /s/tests //' \
			qtpass.pro || die "sed for qtpass.pro failed"
	fi
}

src_configure() {
	eqmake6 PREFIX="${EPREFIX}"/usr
}

src_test() {
	local -x QT_QPA_PLATFORM=offscreen
	default
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs

	insinto /usr/share/qtpass/translations
	doins src/.qm/*.qm

	doman qtpass.1
	domenu qtpass.desktop
	newicon artwork/icon.png qtpass-icon.png
	insinto /usr/share/metainfo
	doins qtpass.appdata.xml
}
