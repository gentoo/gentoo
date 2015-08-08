# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=2
inherit eutils elisp-common

DESCRIPTION="Free computer algebra environment based on Macsyma"
HOMEPAGE="http://maxima.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

# Supported lisps with readline
SUPP_RL="gcl clisp"
# Supported lisps without readline
SUPP_NORL="cmucl sbcl"
SUPP_LISPS="${SUPP_RL} ${SUPP_NORL}"
# Default lisp if none selected
DEF_LISP="sbcl"

IUSE="latex emacs tk nls unicode xemacs X ${SUPP_LISPS} ${IUSE}"

# Languages
LANGS="es pt pt_BR"
for lang in ${LANGS}; do
	IUSE="${IUSE} linguas_${lang}"
done

RDEPEND="X? ( x11-misc/xdg-utils
		 sci-visualization/gnuplot[gd]
		 tk? ( dev-lang/tk:0 ) )
	latex? ( virtual/latex-base )
	emacs? ( virtual/emacs
		latex? ( app-emacs/auctex ) )
	xemacs? ( app-editors/xemacs
		latex? ( app-emacs/auctex ) )"

PDEPEND="emacs? ( app-emacs/imaxima )"

# create lisp dependencies
for LISP in ${SUPP_LISPS}; do
	if [ "${LISP}" = "gcl" ]
	then
		RDEPEND="${RDEPEND} gcl? ( >=dev-lisp/gcl-2.6.8_pre[ansi] )"
	else
		RDEPEND="${RDEPEND} ${LISP}? ( dev-lisp/${LISP} )"
	fi
	DEF_DEP="${DEF_DEP} !${LISP}? ( "
done
DEF_DEP="${DEF_DEP} dev-lisp/${DEF_LISP}"
for LISP in ${SUPP_NORL}; do
	RDEPEND="${RDEPEND} ${LISP}? ( app-misc/rlwrap )"
	[[ ${LISP} = ${DEF_LISP} ]] && \
		DEF_DEP="${DEF_DEP} app-misc/rlwrap"
done
for LISP in ${SUPP_LISPS}; do
	DEF_DEP="${DEF_DEP} )"
done

RDEPEND="${RDEPEND}
	${DEF_DEP}"

DEPEND="${RDEPEND}
	sys-apps/texinfo"

TEXMF=/usr/share/texmf-site

pkg_setup() {
	LISPS=""

	for LISP in ${SUPP_LISPS}; do
		use ${LISP} && LISPS="${LISPS} ${LISP}"
	done

	RL=""

	for LISP in ${SUPP_NORL}; do
		use ${LISP} && RL="yes"
	done

	if [ -z "${LISPS}" ]; then
		ewarn "No lisp specified in USE flags, choosing ${DEF_LISP} as default"
		LISPS="${DEF_LISP}"
		RL="yes"
	fi
}

src_prepare() {
	# use xdg-open to view ps, pdf
	epatch "${FILESDIR}"/${PN}-xdg-utils.patch
	epatch "${FILESDIR}"/${PN}-no-init-files.patch
	# remove rmaxima if neither cmucl nor sbcl
	if [ -z "${RL}" ]; then
		sed -e '/^@WIN32_FALSE@bin_SCRIPTS/s/rmaxima//' \
			-i "${S}"/src/Makefile.in \
			|| die "sed for rmaxima failed"
	fi
	# don't install imaxima, since we have a separate package for it
	sed -i -e '/^SUBDIRS/s/imaxima//' interfaces/emacs/Makefile.in \
		|| die "sed for imaxima failed"
}

src_configure() {
	local myconf=""
	for LISP in ${LISPS}; do
		myconf="${myconf} --enable-${LISP}"
	done

	# remove xmaxima if no tk
	if use tk; then
		myconf="${myconf} --with-wish=wish"
	else
		myconf="${myconf} --with-wish=none"
		sed -i \
			-e '/^SUBDIRS/s/xmaxima//' \
			interfaces/Makefile.in || die "sed for tk failed"
	fi

	# enable existing translated doc
	if use nls; then
		for lang in ${LANGS}; do
			if use "linguas_${lang}"; then
				myconf="${myconf} --enable-lang-${lang}"
				use unicode && myconf="${myconf} --enable-lang-${lang}-utf8"
			fi
		done
	fi

	econf ${myconf}
}

src_install() {
	einstall emacsdir="${D}${SITELISP}/${PN}" || die "einstall failed"

	use tk && make_desktop_entry xmaxima xmaxima \
		/usr/share/${PN}/${PV}/xmaxima/maxima-new.png \
		"Science;Math;Education"

	if use latex; then
		insinto ${TEXMF}/tex/latex/emaxima
		doins interfaces/emacs/emaxima/emaxima.sty
	fi

	# do not use dodoc because interfaces can't read compressed files
	# read COPYING before attempt to remove it from dodoc
	insinto /usr/share/${PN}/${PV}/doc
	doins AUTHORS COPYING README README.lisps || die
	dodir /usr/share/doc
	dosym ../${PN}/${PV}/doc /usr/share/doc/${PF} || die

	if use emacs; then
		elisp-site-file-install "${FILESDIR}"/50maxima-gentoo.el || die
	fi
}

pkg_preinst() {
	# some lisps do not read compress info files (bug #176411)
	for infofile in "${D}"/usr/share/info/*.bz2 ; do
		bunzip2 "${infofile}"
	done
	for infofile in "${D}"/usr/share/info/*.gz ; do
		gunzip "${infofile}"
	done
}

pkg_postinst() {
	use emacs && elisp-site-regen
	use latex && mktexlsr
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
