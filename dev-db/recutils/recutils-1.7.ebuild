# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/recutils/recutils-1.7.ebuild,v 1.1 2014/10/31 01:40:49 radhermit Exp $

EAPI=5

inherit autotools eutils elisp-common

DESCRIPTION="Tools and libraries to access human-editable, plain text databases"
HOMEPAGE="http://www.gnu.org/software/recutils/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="crypt curl emacs mdb nls static-libs +uuid"

RDEPEND="sys-libs/readline
	crypt? (
		dev-libs/libgcrypt:0=
		dev-libs/libgpg-error
	)
	curl? ( net-misc/curl )
	emacs? (
		app-emacs/org-mode
		virtual/emacs
	)
	mdb? (
		app-office/mdbtools
		dev-libs/glib:2
	)
	nls? ( virtual/libintl )
	uuid? ( sys-apps/util-linux )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	epatch "${FILESDIR}"/${P}-automagic.patch

	# don't unconditionally install emacs files
	sed -i "/^dist_lisp_DATA/d" etc/Makefile.am || die

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable crypt encryption) \
		$(use_enable curl) \
		$(use_enable mdb) \
		$(use_enable nls) \
		$(use_enable uuid) \
		$(use_enable static-libs static)
}

src_compile() {
	default

	if use emacs ; then
		elisp-compile etc/*.el || die
	fi
}

src_test() {
	# tests have parallel issues
	emake -j1 check
}

src_install() {
	default
	prune_libtool_files

	if use emacs ; then
		elisp-install ${PN} etc/*.{el,elc} || die
		elisp-site-file-install "${FILESDIR}"/${SITEFILE} || die
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
