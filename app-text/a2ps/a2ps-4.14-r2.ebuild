# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/a2ps/a2ps-4.14-r2.ebuild,v 1.5 2012/01/06 02:11:56 ottxor Exp $

EAPI=3
inherit eutils autotools elisp-common

DESCRIPTION="Any to PostScript filter"
HOMEPAGE="http://www.inf.enst.fr/~demaille/a2ps/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz
	linguas_ja? ( mirror://gentoo/${P}-ja_nls.patch.gz )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="emacs nls latex vanilla userland_BSD userland_GNU linguas_ja"

RESTRICT="test"

DEPEND=">=dev-util/gperf-2.7.2
	|| ( >=dev-util/yacc-1.9.1 sys-devel/bison )
	app-text/ghostscript-gpl
	app-text/libpaper
	>=app-text/psutils-1.17
	emacs? ( virtual/emacs )
	latex? ( virtual/latex-base )
	nls? ( sys-devel/gettext )"
RDEPEND="app-text/ghostscript-gpl
	app-text/wdiff
	app-text/libpaper
	userland_GNU? ( || ( >=sys-apps/coreutils-6.10-r1 ) )
	userland_BSD? ( sys-freebsd/freebsd-ubin )
	>=app-text/psutils-1.17
	emacs? ( virtual/emacs )
	latex? ( virtual/latex-base )
	nls? ( virtual/libintl )"

SITEFILE="50${PN}-gentoo.el"

S="${WORKDIR}/${PN}-${PV:0:4}"

src_unpack() {
	unpack ${P}.tar.gz
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-4.13c-locale-gentoo.diff"
	# this will break
	#epatch "${FILESDIR}/${PN}-4.13c-stdarg.patch"
	use vanilla || epatch "${FILESDIR}/${PN}-4.13-stdout.diff"
	if use linguas_ja ; then
		epatch "${DISTDIR}/${P}-ja_nls.patch.gz"
		# bug #335803
		epatch "${FILESDIR}/${P}-ja-cleanup.patch"
	else
		epatch "${FILESDIR}/${P}-cleanup.patch"
	fi

	# fix fnmatch replacement, bug #134546
	epatch "${FILESDIR}/${PN}-4.13c-fnmatch-replacement.patch"

	# bug #122026
	epatch "${FILESDIR}/${P}-psset.patch"

	# fix emacs printing, bug #114627
	epatch "${FILESDIR}/a2ps-4.13c-emacs.patch"

	# fix chmod error, #167670
	epatch "${FILESDIR}/a2ps-4.13-manpage-chmod.patch"

	# add configure check for mempcpy, bug 216588
	epatch "${FILESDIR}/${P}-check-mempcpy.patch"

	# fix compilation error due to invalid stpcpy() prototype, bug 216588
	epatch "${FILESDIR}/${P}-fix-stpcpy-proto.patch"

	# fix compilation error due to obstack.h issue, bug 269638
	epatch "${FILESDIR}/${P}-ptrdiff_t.patch"

	eautoreconf
}

src_configure() {
	local myconf="COM_netscape=no COM_acroread=no"

	if ! use emacs ; then
		myconf="${myconf} EMACS=no"
	fi

	if ! use latex ; then
		myconf="${myconf} COM_latex=no"
	fi

	export LANG=C LC_ALL=C

	econf \
		--sysconfdir="${EPREFIX}"/etc/a2ps \
		$(use_enable nls) \
		${myconf}
}

src_compile() {
	# parallel make b0rked
	emake -j1 || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" \
		lispdir="${EPREFIX}${SITELISP}/${PN}" \
		install || die "emake install failed"

	if use emacs; then
		elisp-site-file-install "${FILESDIR}/${SITEFILE}" || die
	fi

	dodoc ANNOUNCE AUTHORS ChangeLog FAQ NEWS README* THANKS TODO
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
