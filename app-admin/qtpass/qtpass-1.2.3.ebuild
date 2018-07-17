# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P="QtPass-${PV}"

inherit desktop qmake-utils virtualx

DESCRIPTION="multi-platform GUI for pass, the standard unix password manager"
HOMEPAGE="https://qtpass.org/"
SRC_URI="https://github.com/IJHack/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="app-admin/pass
	dev-qt/qtcore:5
	dev-qt/qtgui:5[xcb]
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	net-misc/x11-ssh-askpass"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
	dev-qt/qtsvg:5
	test? ( dev-qt/qttest:5 )"

S="${WORKDIR}/${MY_P}"

DOCS=( {CHANGELOG,CONTRIBUTING,FAQ,README}.md )

src_prepare() {
	default

	if ! use test ; then
		sed -i '/SUBDIRS += src /s/tests //' \
			qtpass.pro || die "sed for qtpass.pro failed"
	fi
}

src_configure() {
	eqmake5 PREFIX="${D}"/usr
}

src_test() {
	virtx default
}

src_install() {
	default

	insinto /usr/share/"${PN}"/translations
	doins localization/*.qm

	doman "${PN}".1
	domenu "${PN}".desktop
	newicon artwork/icon.png "${PN}"-icon.png
	insinto /usr/share/appdata
	doins qtpass.appdata.xml
}
