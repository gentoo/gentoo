# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# Convert package name to upstram package name
KICAD_DOC_PN=${PN/-bin}
KICAD_DOC_P=${KICAD_DOC_PN}-${PV}

inherit eutils

DESCRIPTION="Electronic Schematic and PCB design tools manuals"
HOMEPAGE="http://www.kicad-pcb.org/"
SRC_URI="http://downloads.kicad-pcb.org/docs/${KICAD_DOC_P}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( GPL-3+ CC-BY-3.0 ) GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="epub html +pdf"
LANGS="ca de en es fr id it ja nl pl ru"
for lang in ${LANGS}; do
	LUSE+=" l10n_${lang}"
done
IUSE+=${LUSE}
REQUIRED_USE="|| ( epub html pdf ) ^^ ( ${LUSE} )"
unset lang
unset LUSE

DEPEND=""
RDEPEND="!!app-doc/kicad-doc"

S="${WORKDIR}/${KICAD_DOC_P}"

src_install() {
	local docpath="/usr/share/doc/kicad/help"

	insinto ${docpath}/${L10N}
	docompress -x ${docpath}/${L10N}

	if use epub ; then
		doins "${S}/share/doc/kicad/help/${L10N}"/*.epub
	fi

	if use html ; then
		doins "${S}/share/doc/kicad/help/${L10N}"/*.html
		doins -r "${S}/share/doc/kicad/help/${L10N}/images"
	fi

	if use pdf ; then
		doins "${S}/share/doc/kicad/help/${L10N}"/*.pdf
	fi
}
