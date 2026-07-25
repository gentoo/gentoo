# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Electronic Schematic and PCB design tools manuals"
HOMEPAGE="https://docs.kicad.org/"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.com/kicad/services/kicad-doc.git"
	inherit git-r3
	# x11-misc-util/macros only required on live ebuilds
	LIVE_DEPEND=">=x11-misc/util-macros-1.18"
else
	SRC_URI="https://gitlab.com/kicad/services/${PN}/-/archive/${PV}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~arm64 ~riscv ~x86"
fi

LICENSE="|| ( GPL-3+ CC-BY-3.0 ) GPL-2"
SLOT="0"
IUSE="+html pdf"

LANG_USE=" l10n_ca l10n_de l10n_en l10n_es l10n_fr l10n_id l10n_it l10n_ja l10n_nl l10n_pl l10n_ru l10n_zh"
IUSE+=${LANG_USE}
REQUIRED_USE="|| ( html pdf ) ^^ ( ${LANG_USE} )"
unset LANG_USE

# pdf uses pandoc/xelatex pipeline instead of upstream's asciidoctor-web-pdf (npm)
BDEPEND="
	>=dev-ruby/asciidoctor-2.0.12
	>=app-text/po4a-0.45
	>=sys-devel/gettext-0.18
	dev-perl/Unicode-LineBreak
	dev-util/source-highlight
	pdf? (
		app-text/pandoc
		dev-texlive/texlive-xetex
		media-fonts/noto-cjk
		media-fonts/dejavu
	)"

PATCHES=(
	"${FILESDIR}"/${PN}-10.0.0-pandoc-pdf-generator.patch
)

src_configure() {
	local languages="${L10N// /;}"
	local mycmakeargs=(
		-DPDF_GENERATOR="$(usex pdf PANDOC ASCIIDOCTORPDF)"
		-DBUILD_FORMATS="$(usev html);$(usev pdf)"
		-DLANGUAGES="${languages}"
		-DKICAD_DOC_PATH="${EPREFIX}"/usr/share/doc/${P}/help
	)
	cmake_src_configure
}
