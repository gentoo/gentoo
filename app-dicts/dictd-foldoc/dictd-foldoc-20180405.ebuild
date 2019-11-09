# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="The Free On-line Dictionary of Computing for dict"
HOMEPAGE="https://foldoc.org/"
SRC_URI="https://web.archive.org/web/20180405153121/http://foldoc.org/Dictionary -> $P.txt"

LICENSE="FDL-1.1+"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"

DEPEND=">=app-text/dictd-1.5.5"

S="$WORKDIR"

src_unpack() {
	cp "$DISTDIR/$A" foldoc.txt
}

src_prepare() {
	eapply_user
	sed -e '/^$/{N;s/\n\([^\t]\+\)/\1/g;T;h;n;d}' -i foldoc.txt
}

src_compile() {
	tail -n +3 foldoc.txt | \
		dictfmt -u "$HOMEPAGE/Dictionary" \
		-s "The Free On-line Dictionary of Computing (version $PV)" \
		--utf8 \
		-f foldoc
	dictzip foldoc.dict
}

src_install() {
	insinto /usr/lib/dict
	doins foldoc.dict.dz foldoc.index || die
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
