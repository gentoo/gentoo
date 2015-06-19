# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-calculators/speedcrunch/speedcrunch-0.11-r1.ebuild,v 1.1 2014/02/04 12:01:38 jlec Exp $

EAPI=5

PLOCALES="ca_ES cs_CZ de_DE en_GB en_US es_AR es_ES et_EE eu_ES fi_FI
	fr_FR he_IL hu_HU id_ID it_IT ja_JP ko_KR lv_LV nb_NO nl_NL pl_PL pt_BR
	pt_PT ro_RO ru_RU sv_SE vi_VN zh_CN"

CMAKE_MAKEFILE_GENERATOR=ninja

inherit cmake-utils l10n

DESCRIPTION="Fast and usable calculator for power users"
HOMEPAGE="http://speedcrunch.org/"
SRC_URI="https://github.com/${PN}/SpeedCrunch/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc"

DEPEND="dev-qt/qtgui:4"
RDEPEND="${DEPEND}"

S="${WORKDIR}/SpeedCrunch-${PV}/src"

src_prepare() {
	my_rm_loc() {
		rm "resources/locale/${1}.qm" || die
		sed -i resources/speedcrunch.qrc \
			-e "s|<file>locale/${1}.qm</file>||" || die
		sed -i gui/mainwindow.cpp \
			-e "s|map.insert(QString::fromUtf8(\".*, QLatin1String(\"${1}\"));||" || die
	}

	l10n_find_plocales_changes 'resources/locale' '' '.qm'
	l10n_for_each_disabled_locale_do my_rm_loc

	cmake-utils_src_prepare
}

src_install() {
	cmake-utils_src_install
	cd .. || die
	doicon -s scalable gfx/speedcrunch.svg
	use doc && dodoc doc/*.pdf
}
