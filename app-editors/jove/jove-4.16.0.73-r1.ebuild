# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Jonathan's Own Version of Emacs, a light emacs-like editor without LISP bindings"
HOMEPAGE="ftp://ftp.cs.toronto.edu/cs/ftp/pub/hugh/jove-dev/"
SRC_URI="ftp://ftp.cs.toronto.edu/cs/ftp/pub/hugh/jove-dev/${PN}${PV}.tgz"

LICENSE="JOVE"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc"

RDEPEND="sys-libs/ncurses:0="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${PN}${PV}"

PATCHES=(
	"${FILESDIR}"/${PN}-4.16.0.70.3.1-getline.patch
	"${FILESDIR}"/${P}-build.patch
	"${FILESDIR}"/${P}-sendmail.patch
	"${FILESDIR}"/${P}-doc.patch
)

src_compile() {
	tc-export CC

	emake OPTFLAGS="${CFLAGS}" \
		SYSDEFS="-DSYSVR4 -D_XOPEN_SOURCE=500 -D_XOPEN_STREAMS=-1" \
		TERMCAPLIB="$("$(tc-getPKG_CONFIG)" --libs ncurses)"

	if use doc; then
		# Full manual (*not* man page)
		emake doc/jove.man
	fi
}

src_install() {
	emake DESTDIR="${D}" install
	keepdir /var/lib/jove/preserve

	dodoc README
	if use doc; then
		dodoc doc/jove.man
	fi
}
