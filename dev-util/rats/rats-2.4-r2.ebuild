# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools edos2unix

DESCRIPTION="RATS - Rough Auditing Tool for Security"
HOMEPAGE="https://github.com/andrew-d/rough-auditing-tool-for-security"
# No tags available in the GitHub port
SRC_URI="https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/rough-auditing-tool-for-security/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"

RDEPEND="dev-libs/expat:="
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-2.4-fix-build-system.patch )

src_prepare() {
	default

	local f
	while IFS="" read -d $'\0' -r f; do
		einfo "Converting ${f} from CRLF to LF"
		edos2unix "${f}"
	done < <(find \( -name '*.[chl]' -o -name '*.in' -o -name '*.am' \) -print0)

	# Clang 16
	eautoreconf
}

src_configure() {
	econf --datadir="${EPREFIX}/usr/share/${PN}/"
}

pkg_postinst() {
	ewarn "Please be careful when using this program with it's force language"
	ewarn "option, '--language <LANG>' it may take huge amounts of memory when"
	ewarn "it tries to treat binary files as some other type."
}
