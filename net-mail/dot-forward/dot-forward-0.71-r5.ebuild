# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fixheadtails qmail

DESCRIPTION="Reads sendmail's .forward files under qmail"
HOMEPAGE="http://cr.yp.to/dot-forward.html"
SRC_URI="http://cr.yp.to/software/${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-fix-build-for-clang16.patch.xz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 sparc x86"

# See bug 97850
RESTRICT="test"

DEPEND="
	acct-group/nofiles
	acct-group/qmail
"

RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PV}-errno.patch
	"${WORKDIR}"/${P}-fix-build-for-clang16.patch
)

DOCS=(
	BLURB
	CHANGES
	FILES
	INSTALL
	README
	TARGETS
	THANKS
	TODO
)

src_prepare() {
	default

	ht_fix_file Makefile
}

src_configure() {
	qmail_set_cc
}

src_compile() {
	emake prog
}

src_install() {
	einstalldocs
	doman *.1

	insopts -o root -g qmail -m 755
	insinto "${QMAIL_HOME}"/bin
	doins dot-forward
}
