# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit fixheadtails

DESCRIPTION="a mail filter written in Scheme"
HOMEPAGE="http://0xcc.net/scmail/"
SRC_URI="http://0xcc.net/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ia64 ~ppc x86"
IUSE=""

RDEPEND="dev-scheme/gauche:="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-doc-encoding.patch
	"${FILESDIR}"/${PN}-gauche-0.9.patch
	"${FILESDIR}"/${PN}-undefined-reference.patch
)
HTML_DOCS=( doc/{${PN},scbayes}{,-ja}.html )

src_prepare() {
	default

	ht_fix_file tests/scmail-commands
	# replace make -> $(MAKE)
	sed -i "s/make\( \|$\)/\$(MAKE)\1/g" Makefile
}

src_install() {
	emake \
		PREFIX="${ED}/usr" \
		SITELIBDIR="${ED}$(gauche-config --sitelibdir)" \
		DATADIR="${ED}/usr/share/doc/${P}" \
		install
	einstalldocs
}
