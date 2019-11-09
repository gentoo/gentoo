# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="The Jargon File for dict"
HOMEPAGE="http://www.catb.org/~esr/jargon/index.html"
SRC_URI="http://www.catb.org/~esr/jargon/oldversions/jarg${PV//.}.txt"

LICENSE="public-domain"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"

DEPEND=">=app-text/dictd-1.5.5"

S="$WORKDIR"

src_unpack() {
	cp "$DISTDIR/$A" jargon.txt
}

src_prepare() {
	eapply_user
	# This sed script works for all versions >=3.0.0 until <4.4.0 (when the
	# entire format changes).
	sed -e '/^The Jargon Lexicon/,/:(Lexicon Entries End Here):/!{w jargon.doc' -e 'd}' -i jargon.txt
	sed -e 's/^    \s*/\t/' -e 's/^   //' -i jargon.txt
	sed -e 's/\([^\t]\)\t/\1  /g' -i jargon.txt
	sed -e 's/^\(:[^:]*:\)\s*/\1/' -i jargon.txt
	sed -e '/^= . =/,/^$/d' -i jargon.txt
	sed -e '/^\S/{: l;N;s/\n *\(.\)/ \1/g;t l}' \
		-e 's/\([^A-Za-z ]\) \+\([2-9][0-9]\?\|1[0-9]\)\.\( \+\|$\)/\1\n\n\2. /g' \
		-e 's/^\([2-9][0-9]\?\|1[0-9]\)\.\( \+\|$\)/\n\1. /g' \
		-i jargon.txt
}

src_compile() {
	dictfmt -u "$SRC_URI" \
		-s "The Jargon File (version $PV)" \
		--columns 80 \
		-j jargon \
		< jargon.txt
	dictzip jargon.dict
}

src_install() {
	newdoc jargon.doc jargon.txt
	insinto /usr/lib/dict
	doins jargon.dict.dz jargon.index || die
}

pkg_preinst() {
	HAS_OLD_VERSION=$(has_version app-dicts/$PN)
}

pkg_postinst() {
	if $HAS_OLD_VERSION ; then
		elog "You must restart your dictd server before the $PN dictionary is"
		elog "completely updated.  If you are using OpenRC, this may be accomplished by"
		elog "running '/etc/init.d/dictd restart'."
	else
		elog "You must register $PN and restart your dictd server before the"
		elog "dictionary is available for use.  If you are using OpenRC, both tasks may be"
		elog "accomplished by running '/etc/init.d/dictd restart'."
	fi
}

pkg_postrm() {
	elog "You must unregister $PN and restart your dictd server before the"
	elog "dictionary is completely removed.  If you are using OpenRC, both tasks may be"
	elog "accomplished by running '/etc/init.d/dictd restart'."
}
