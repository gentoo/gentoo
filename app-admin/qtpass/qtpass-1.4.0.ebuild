# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop qmake-utils virtualx

DESCRIPTION="Multi-platform GUI for pass, the standard unix password manager"
HOMEPAGE="https://qtpass.org https://github.com/IJHack/qtpass"
SRC_URI="https://github.com/IJHack/qtpass/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/QtPass-${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="|| ( app-admin/pass app-admin/gopass )
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	net-misc/x11-ssh-askpass"
DEPEND="${RDEPEND}
	dev-qt/qtsvg:5
	test? ( dev-qt/qttest:5 )"
BDEPEND="dev-qt/linguist-tools:5"

DOCS=( {CHANGELOG,CONTRIBUTING,FAQ,README}.md )

src_prepare() {
	default

	if ! use test ; then
		sed -i '/SUBDIRS += src /s/tests //' \
			qtpass.pro || die "sed for qtpass.pro failed"
	fi
}

src_configure() {
	eqmake5 PREFIX="${EPREFIX}"/usr
}

src_test() {
	virtx default
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
