# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P="QtPass-${PV}"
PLOCALES="ar_MA ca cs_CZ de_DE de_LU el_GR en_GB en_US es_ES fr_BE fr_FR fr_LU
gl_ES he_IL hu_HU it_IT lb_LU nl_BE nl_NL pl_PL pt_PT ru_RU sv_SE zh_CN"

inherit desktop l10n qmake-utils

DESCRIPTION="multi-platform GUI for pass, the standard unix password manager"
HOMEPAGE="https://qtpass.org/"
SRC_URI="https://github.com/IJHack/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

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

DOCS=( CHANGELOG.md CONTRIBUTING.md FAQ.md README.md  )

src_prepare() {
	default

	if ! use test ; then
		sed -i '/SUBDIRS += src /s/tests //' \
			qtpass.pro || die "sed for qtpass.pro failed"
	fi

	l10n_find_plocales_changes localization localization_ .ts
}

src_configure() {
	eqmake5 PREFIX="${D}"/usr
}

src_compile() {
	default

	local lr
	lr="$(qt5_get_bindir)"/lrelease
	l10n_build() {
		$lr localization/localization_"${1}".ts || die "lrelease ${1} failed"
	}
	l10n_for_each_locale_do l10n_build
}

src_install() {
	default

	insinto /usr/share/"${PN}"/translations
	doins localization/*.qm

	doman "${PN}".1
	insinto /usr/share/applications
	doins "${PN}".desktop
	newicon artwork/icon.png "${PN}"-icon.png
	insinto /usr/share/appdata
	doins qtpass.appdata.xml
}
