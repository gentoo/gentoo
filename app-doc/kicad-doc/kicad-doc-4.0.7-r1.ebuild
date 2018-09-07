# Copyright 1999-2018 Gentoo Foundation
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
LANGS="ca de en es fr id it ja pl"
for lang in ${LANGS}; do
	LUSE+=" l10n_${lang}"
done
IUSE+=${LUSE}
REQUIRED_USE="|| ( html pdf ) ^^ ( ${LUSE} )"
unset lang
unset LUSE

DEPEND="
	>=app-text/asciidoc-8.6.9
	>=app-text/dblatex-0.3.10
	>=app-text/po4a-0.45
	>=sys-devel/gettext-0.18
	dev-perl/Unicode-LineBreak
	dev-util/source-highlight
	l10n_ca? ( dev-texlive/texlive-langspanish )
	l10n_de? ( dev-texlive/texlive-langgerman )
	l10n_en? ( dev-texlive/texlive-langenglish )
	l10n_es? ( dev-texlive/texlive-langspanish )
	l10n_fr? ( dev-texlive/texlive-langfrench )
	l10n_it? ( dev-texlive/texlive-langitalian )
	l10n_ja? ( dev-texlive/texlive-langjapanese media-fonts/vlgothic )
	l10n_pl? ( dev-texlive/texlive-langpolish )"
RDEPEND=""

src_configure() {
	local mycmakeargs=(
		-DBUILD_FORMATS="$(usev html);$(usev pdf)"
		-DSINGLE_LANGUAGE="${L10N}"
	)
	cmake-utils_src_configure
}
