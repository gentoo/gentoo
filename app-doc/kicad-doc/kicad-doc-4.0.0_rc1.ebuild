# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils vcs-snapshot

# As per KiCad site the version of docs they will bundle with 4.0.0 final
# is the state of the docs at the release date. Thus I will follow the same
# logic when picking revisions for KiCad-4.0.0 RCs
DOC_REVISION="b5e8a2efb9015b420bd83541d4b580ce2f7a89e6"

DESCRIPTION="Electronic Schematic and PCB design tools manuals."
HOMEPAGE="http://www.kicad-pcb.org"
SRC_URI="https://github.com/KiCad/${PN}/tarball/${DOC_REVISION} -> ${P}.tar.gz"

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
		-DCMAKE_INSTALL_PREFIX="/usr/share/doc/${PF}"
	)
	cmake-utils_src_configure
}
