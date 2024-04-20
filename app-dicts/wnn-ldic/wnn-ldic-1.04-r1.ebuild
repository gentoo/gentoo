# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Wnn dictionary for librarian"
#HOMEPAGE="http://www.tulips.tsukuba.ac.jp/misc/export/cat/ldic"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/ldic-${PV}-wnn.txt"
S="${WORKDIR}"

LICENSE="HPND"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

DEPEND="app-i18n/freewnn"

src_unpack() {
	:
}

src_compile() {
	local atod=atod
	if has_version "<app-i18n/freewnn-1.1.1_alpha23"; then
		atod="${BROOT}"/usr/bin/Wnn4/atod
	fi
	"${atod}" lib.dic < "${DISTDIR}"/${A} || die
}

src_install() {
	insinto /usr/lib/wnn/ja_JP/dic/misc
	doins lib.dic
}

pkg_postinst() {
	elog "lib.dic is installed in ${EPREFIX}/usr/lib/wnn/ja_JP/dic/misc."
	elog "You have to edit your wnnenvrc or eggrc to use it."
}
