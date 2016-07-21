# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

inherit elisp-common flag-o-matic eutils multilib

DESCRIPTION="GNU Smalltalk"
HOMEPAGE="http://smalltalk.gnu.org"
SRC_URI="mirror://gnu/smalltalk/smalltalk-${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="tk readline emacs gtk gmp"

DEPEND="app-arch/zip
	sys-libs/gdbm
	sys-apps/debianutils
	dev-libs/libsigsegv
	virtual/libffi
	emacs? ( virtual/emacs )
	readline? ( sys-libs/readline )
	tk? ( dev-lang/tk )
	gtk? ( =x11-libs/gtk+-2* )
	gmp? ( dev-libs/gmp )"
RDEPEND=""

S="${WORKDIR}/smalltalk-${PV}"

SITEFILE=50gnu-smalltalk-gentoo.el

src_prepare() {
	epatch "${FILESDIR}"/SequenceableCollection-size-3.2.4.patch
}

src_configure() {
	replace-flags '-O3' '-O2'
	econf \
		--libdir=/usr/$(get_libdir) \
		--with-system-libsigsegv \
		--with-system-libffi \
		--with-system-libltdl \
		$(use_with emacs emacs) \
		$(use_with readline readline) \
		$(use_with gmp gmp) \
		$(use_with tk tcl /usr/$(get_libdir)) \
		$(use_with tk tk /usr/$(get_libdir)) \
		$(use_enable gtk gtk)
}

src_compile() {
	emake || die "emake failed"
	use emacs && elisp-compile *.el
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS COPYING* ChangeLog NEWS README THANKS TODO
	if use emacs; then
		elisp-install "${PN}" *.el *.elc
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi
	fperms 0444 /usr/share/smalltalk/packages.xml
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
