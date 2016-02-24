# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=5
inherit multilib elisp-common

DESCRIPTION="FriCAS is a fork of Axiom computer algebra system"
HOMEPAGE="http://${PN}.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-full.tar.bz2"
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Supported lisps, number 0 is the default
LISPS=( sbcl cmucl     gcl ecls   clisp clozurecl )
# command name: . means just ${LISP}
COMS=(  .    lisp      .   ecl    .     ccl       )

IUSE="${LISPS[*]} X emacs gmp"
RDEPEND="X? ( x11-libs/libXpm x11-libs/libICE )
	emacs? ( virtual/emacs )
	gmp? ( dev-libs/gmp:= )"

# Generating lisp deps
n=${#LISPS[*]}
for ((n--; n > 0; n--)); do
	LISP=${LISPS[$n]}
	DEP="dev-lisp/${LISP}"
	RDEPEND="${RDEPEND} ${LISP}? ( ${DEP}:= ) !${LISP}? ("
done
DEP="dev-lisp/${LISPS[0]}"
RDEPEND="${RDEPEND} ${DEP}:="
n=${#LISPS[*]}
for ((n--; n > 0; n--)); do
	RDEPEND="${RDEPEND} )"
done

DEPEND="${RDEPEND}"

# necessary for clisp and gcl
RESTRICT="strip"

src_configure() {
	local LISP n
	LISP=sbcl
	n=${#LISPS[*]}
	for ((n--; n > 0; n--)); do
		if use ${LISPS[$n]}; then
			LISP=${COMS[$n]}
			if [ "${LISP}" = "." ]; then
				LISP=${LISPS[$n]}
			fi
		fi
	done
	einfo "Using lisp: ${LISP}"

	# aldor is not yet in portage
	econf --disable-aldor --with-lisp=${LISP} $(use_with X x) $(use_with gmp)
}

src_compile() {
	# bug #300132
	emake -j1
}

src_test() {
	emake -j1 all-input
}

src_install() {
	emake -j1 DESTDIR="${D}" install
	dodoc README FAQ

	if use emacs; then
		sed -e "s|(setq load-path (cons (quote \"/usr/$(get_libdir)/fricas/emacs\") load-path)) ||" \
			-i "${D}"/usr/bin/efricas \
			|| die "sed efricas failed"
		elisp-install ${PN} "${D}"/usr/$(get_libdir)/${PN}/emacs/*.el
		elisp-site-file-install "${FILESDIR}"/64${PN}-gentoo.el
	else
		rm "${D}"/usr/bin/efricas || die "rm efricas failed"
	fi
	rm -r "${D}"/usr/$(get_libdir)/${PN}/emacs || die "rm -r emacs failed"
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
