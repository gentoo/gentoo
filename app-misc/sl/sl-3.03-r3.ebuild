# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils toolchain-funcs flag-o-matic

SL_PATCH="sl5-1.patch"

DESCRIPTION="sophisticated graphical program which corrects your miss typing"
HOMEPAGE="http://www.tkl.iis.u-tokyo.ac.jp/~toyoda/index_e.html http://www.izumix.org.uk/sl/"
SRC_URI="http://www.tkl.iis.u-tokyo.ac.jp/~toyoda/sl/${PN}.tar
	!vanilla? (
		http://www.linet.gr.jp/~izumi/sl/${SL_PATCH}
		http://www.sodan.ecc.u-tokyo.ac.jp/~okayama/sl/${PN}.en.1.gz
	)"

LICENSE="freedist"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86 ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="debug linguas_ja vanilla"

REQUIRED_USE="debug? ( !vanilla )"

DEPEND="sys-libs/ncurses"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

pkg_setup() {
	tc-export CC
	use debug && append-cppflags -DDEBUG
}

src_prepare() {
	if ! use vanilla ; then
		epatch -p1 "${DISTDIR}/${SL_PATCH}"
		epatch "${FILESDIR}/${P}-gentoo.diff"
		epatch "${FILESDIR}/fix_compilation.patch"
	fi

	cp "${FILESDIR}"/Makefile "${S}" || die

	if use linguas_ja; then
		iconv -f ISO-2022-JP -t EUC-JP sl.1 > sl.ja.1
	fi
}

src_install() {
	dobin sl
	dodoc sl.txt

	if ! use vanilla ; then
		newman "${WORKDIR}/sl.en.1" sl.1
	fi

	if use linguas_ja ; then
		dodoc README*
		insinto /usr/share/man/ja/man1
		newins sl.ja.1 sl.1
	fi
}
