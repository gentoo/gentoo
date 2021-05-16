# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Tools for counting Source Lines of Code (SLOC) for a large number of languages"
HOMEPAGE="http://www.dwheeler.com/sloccount/"
SRC_URI="http://www.dwheeler.com/sloccount/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"

RDEPEND="dev-lang/perl"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-libexec.patch
	"${FILESDIR}"/${P}-coreutils-tail-n-fix.patch
	# support for
	# 1) .ebuild
	# 2) #!/sbin/openrc-run
	# 3) CFLAGS/CPPFLAGS/LDFLAGS
	"${FILESDIR}"/${P}-gentoo.patch
)

src_prepare() {
	default

	# fix hard-coded libexec_dir in sloccount
	sed -i "s|libexec_dir=|&\"${EPREFIX}\"|" sloccount || die
}

src_configure() {
	tc-export CC
}

src_test() {
	PATH="${PATH}:${S}" emake test
}

src_install() {
	emake PREFIX="${ED}"/usr DOC_DIR="${ED}"/usr/share/doc/${PF}/ install

	HTML_DOCS=( *.html )
	einstalldocs

	# avoid QA warning
	gunzip "${ED}"/usr/share/man/man1/sloccount.1.gz || die
}
