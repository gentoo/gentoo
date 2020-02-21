# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit multilib elisp-common

DESCRIPTION="FriCAS is a fork of Axiom computer algebra system"
HOMEPAGE="http://fricas.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-full.tar.bz2"
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Supported lisps, number 0 is the default
LISPS=( sbcl cmucl gcl ecls clisp clozurecl )
# Version restrictions, . means no restrictions
REST=(  .    .     .   .    .     . )
# command name: . means just ${LISP}
COMS=(  .    lisp  .   ecl  .     ccl )

IUSE="${LISPS[*]} X emacs gmp"
RDEPEND="X? ( x11-libs/libXpm x11-libs/libICE )
	emacs? ( >=app-editors/emacs-23.1:* )
	gmp? ( dev-libs/gmp:= )"

# Generating lisp deps
n=${#LISPS[*]}
for ((n--; n > 0; n--)); do
	LISP=${LISPS[$n]}
	if [ "${REST[$n]}" = "." ]; then
	    DEP="dev-lisp/${LISP}"
	else
	    DEP="${REST[$n]}"
	fi
	RDEPEND="${RDEPEND} ${LISP}? ( ${DEP}:= ) !${LISP}? ("
done
if [ "${REST[0]}" = "." ]; then
	DEP="dev-lisp/${LISPS[0]}"
else
	DEP="${REST[0]}"
fi
RDEPEND="${RDEPEND} ${DEP}:="
n=${#LISPS[*]}
for ((n--; n > 0; n--)); do
	RDEPEND="${RDEPEND} )"
done

DEPEND="${RDEPEND}"

# necessary for clisp and gcl
RESTRICT="strip"

src_configure() {
	local LISP n GMP
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

	# bug #650788
	if [[ ${LISP} = sbcl || ${LISP} = ccl ]]
	then GMP=$(use_with gmp)
	else GMP=''
	fi

	# aldor is not yet in portage
	econf --disable-aldor --with-lisp=${LISP} $(use_with X x) ${GMP}
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
