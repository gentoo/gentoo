# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit readme.gentoo-r1

DESCRIPTION="Freedoom - Open Source Doom resources"
HOMEPAGE="http://www.nongnu.org/freedoom/"
SRC_URI="https://github.com/freedoom/freedoom/releases/download/v${PV}/freedoom-${PV}.zip
	https://github.com/freedoom/freedoom/releases/download/v${PV}/freedm-${PV}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

S="${WORKDIR}"

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="
A Doom engine is required to play the wad
but games-fps/doomsday doesn't count since it doesn't
have the necessary features.
To play freedoom with Doom engines which do not support
subdirectories, create symlinks by running the following:
(Be careful of overwriting existing wads.)

# cd /usr/share/doom-data
# ln -sn freedoom/*.wad .
"

src_install() {
	insinto /usr/share/doom-data/${PN}
	doins */*.wad
	dodoc "${P}"/CREDITS
	HTMLDOCS="${P}/README.html" einstalldocs
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
