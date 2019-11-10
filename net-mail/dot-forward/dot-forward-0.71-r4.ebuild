# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils fixheadtails qmail

DESCRIPTION="reads sendmail's .forward files under qmail"
HOMEPAGE="http://cr.yp.to/dot-forward.html"
SRC_URI="http://cr.yp.to/software/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE=""

# See bug 97850
RESTRICT="test"

DEPEND="
	acct-group/nofiles
	acct-group/qmail
"

RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PV}-errno.patch
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
