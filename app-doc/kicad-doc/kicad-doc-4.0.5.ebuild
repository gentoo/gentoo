# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Electronic Schematic and PCB design tools manuals"
HOMEPAGE="http://www.kicad-pcb.org/"
SRC_URI="https://github.com/KiCad/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( GPL-3+ CC-BY-3.0 ) GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="html +pdf"
LANGS="en fr it ja nl pl"
for lang in ${LANGS}; do
	LUSE+=" l10n_${lang}"
done
IUSE+=${LUSE}
REQUIRED_USE="|| ( html pdf ) ^^ ( ${LUSE} )"
unset lang
unset LUSE

DEPEND=">=app-text/asciidoc-8.6.9
	>=app-text/dblatex-0.3.10
	app-text/texlive:=[l10n_en?,l10n_fr?,l10n_it?,l10n_ja?,l10n_nl?,l10n_pl?]
	>=app-text/po4a-0.45
	>=sys-devel/gettext-0.18
	dev-util/source-highlight
	dev-perl/Unicode-LineBreak
	l10n_ja? ( media-fonts/vlgothic )"
RDEPEND=""

src_prepare() {
	DOCPATH="KICAD_DOC_INSTALL_PATH share/doc/kicad"
	sed "s|${DOCPATH}|${DOCPATH}-${PV}|g" -i CMakeLists.txt || die "sed failed"
	cmake-utils_src_prepare
}

src_configure() {
	local formats=""
	local doclang=""
	local format lang

	# construct format string
	for format in html pdf; do
		use ${format} && formats+="${format};"
	done

	# find out which language is requested
	for lang in ${LANGS}; do
		if use l10n_${lang}; then
			if [[ -z ${doclang} ]]; then
				doclang="${lang}"
			else
				ewarn "Only one single language can be enabled." \
					"Using \"${doclang}\", ignoring \"${lang}\"."
			fi
		fi
	done

	local mycmakeargs=(
		-DBUILD_FORMATS="${formats}"
		-DSINGLE_LANGUAGE="${doclang}"
	)
	cmake-utils_src_configure
}
