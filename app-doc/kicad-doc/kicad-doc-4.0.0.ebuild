# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils vcs-snapshot

DESCRIPTION="Electronic Schematic and PCB design tools manuals"
HOMEPAGE="http://www.kicad-pcb.org"
SRC_URI="https://github.com/KiCad/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
FUSE="html pdf"
LANGS="en fr it ja nl pl"
LINGUAS=""
for lang in ${LANGS} ; do
	LINGUAS="${LINGUAS} linguas_${lang}"
done
IUSE="${FUSE} ${LINGUAS}"

REQUIRED_USE="( || ( pdf html ) ) ( ^^ ( ${LINGUAS} ) )"

DEPEND=">=app-text/asciidoc-8.6.9
	app-text/dblatex
	>=app-text/po4a-0.45
	>=sys-devel/gettext-0.18
	dev-util/source-highlight
	dev-perl/Unicode-LineBreak
	linguas_ja? ( media-fonts/vlgothic )"
RDEPEND=""

src_prepare() {
	DOCPATH="KICAD_DOC_INSTALL_PATH share/doc/kicad"
	sed "s|${DOCPATH}|${DOCPATH}-${PV}|g" -i CMakeLists.txt || die "sed failed"
}

src_configure() {
	local formats=""
	local doclang=""

	# construct format string
	for format in ${FUSE}; do
		use $format && formats+="${format};"
	done

	# find out which language is requested
	for lang in ${LANGS}; do
		if use linguas_${lang}; then
			doclang=${lang}
		fi
	done

	local mycmakeargs+=(
		-DBUILD_FORMATS="${formats}"
		-DSINGLE_LANGUAGE="${doclang}"
	)
	cmake-utils_src_configure
}
