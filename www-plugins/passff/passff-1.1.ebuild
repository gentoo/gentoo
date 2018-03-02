# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_4 )

inherit python-single-r1

DESCRIPTION="zx2c4 pass manager extension for Firefox (Host Binary)"
HOMEPAGE="https://github.com/passff/passff"
SRC_URI="
	https://github.com/passff/passff/releases/download/${PV}/passff.json -> ${P}.json
	https://github.com/passff/passff/releases/download/${PV}/passff.py -> ${P}.py
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

TARGET_DIR="/usr/lib/mozilla/native-messaging-hosts"

S="${WORKDIR}"

src_unpack() {
	cp "${DISTDIR}/${P}.json" passff.json || die
	cp "${DISTDIR}/${P}.py" passff.py || die
}

src_compile() {
	sed -i "s|PLACEHOLDER|${EPREFIX}${TARGET_DIR}/${PN}.py|" passff.json || die
	python_fix_shebang passff.py
}

src_install() {
	insinto "${TARGET_DIR}"
	doins passff.json
	exeinto "${TARGET_DIR}"
	doexe passff.py
}
