# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils toolchain-funcs

DESCRIPTION="The Linux Security Auditing Tool"
HOMEPAGE="http://usat.sourceforge.net/"
SRC_URI="http://usat.sourceforge.net/code/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="minimal"

DEPEND="dev-lang/perl" # pod2man
RDEPEND="
	${DEPEND}
	!minimal? (
		app-portage/portage-utils
		net-analyzer/nmap
		sys-apps/iproute2
		sys-apps/which
		sys-process/lsof
	)"

PATCHES=(
	"${FILESDIR}/${P}-gentoo.patch"
	"${FILESDIR}/${P}-segfault-fix.patch"
)

HTML_DOCS=( modules.html changelog/changelog.html )

src_prepare() {
	default

	# patch for segmentation fault see bug #184488
	sed -i Makefile.in \
		-e '/^LDFLAGS=/d' \
		-e '/^CFLAGS=/d' \
		|| die "sed Makefile.in"
}

src_compile() {
	tc-export CC
	emake CFLAGS="${CFLAGS}" all manpage
}

src_install() {
	emake DESTDIR="${D}" install installman
	dodoc README* *.txt
	einstalldocs
}
