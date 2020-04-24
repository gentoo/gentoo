# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Open source coding font"
HOMEPAGE="https://be5invis.github.io/Iosevka"
BASE_SRC_URI="https://github.com/be5invis/Iosevka/releases/download/v${PV}"
SRC_URI="
	${BASE_SRC_URI}/01-${P}.zip
	${BASE_SRC_URI}/02-${PN}-term-${PV}.zip
	${BASE_SRC_URI}/03-${PN}-type-${PV}.zip
	${BASE_SRC_URI}/04-${PN}-cc-${PV}.zip
	${BASE_SRC_URI}/05-${PN}-slab-${PV}.zip
	${BASE_SRC_URI}/06-${PN}-term-slab-${PV}.zip
	${BASE_SRC_URI}/07-${PN}-type-slab-${PV}.zip
	${BASE_SRC_URI}/08-${PN}-cc-slab-${PV}.zip
	stylisticsets? (
		${BASE_SRC_URI}/${PN}-ss01-${PV}.zip
		${BASE_SRC_URI}/${PN}-ss02-${PV}.zip
		${BASE_SRC_URI}/${PN}-ss03-${PV}.zip
		${BASE_SRC_URI}/${PN}-ss04-${PV}.zip
		${BASE_SRC_URI}/${PN}-ss05-${PV}.zip
		${BASE_SRC_URI}/${PN}-ss06-${PV}.zip
		${BASE_SRC_URI}/${PN}-ss07-${PV}.zip
		${BASE_SRC_URI}/${PN}-ss08-${PV}.zip
		${BASE_SRC_URI}/${PN}-ss09-${PV}.zip
		${BASE_SRC_URI}/${PN}-ss10-${PV}.zip
		${BASE_SRC_URI}/${PN}-ss11-${PV}.zip
		${BASE_SRC_URI}/${PN}-term-ss01-${PV}.zip
		${BASE_SRC_URI}/${PN}-term-ss02-${PV}.zip
		${BASE_SRC_URI}/${PN}-term-ss03-${PV}.zip
		${BASE_SRC_URI}/${PN}-term-ss04-${PV}.zip
		${BASE_SRC_URI}/${PN}-term-ss05-${PV}.zip
		${BASE_SRC_URI}/${PN}-term-ss06-${PV}.zip
		${BASE_SRC_URI}/${PN}-term-ss07-${PV}.zip
		${BASE_SRC_URI}/${PN}-term-ss08-${PV}.zip
		${BASE_SRC_URI}/${PN}-term-ss09-${PV}.zip
		${BASE_SRC_URI}/${PN}-term-ss10-${PV}.zip
		${BASE_SRC_URI}/${PN}-term-ss11-${PV}.zip
	)
"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="stylisticsets"

BDEPEND="app-arch/unzip"

S="${WORKDIR}"
FONT_S="${S}/ttf"
FONT_SUFFIX="ttf"
