# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WV=${PV%_p*}
GV=${WV//.}

SN="web1913-dict-patches"
SV=${PV##*_}
SD="${SN}-${SV}"

DESCRIPTION="Webster's Revised Unabridged Dictionary (1913) for dict"
HOMEPAGE="http://www.micra.com/"
SRC_URI="ftp://aleph.gutenberg.org/6/6/660/old/pgw${GV}ab.zip
	ftp://aleph.gutenberg.org/6/6/661/old/pgw${GV}c.zip
	ftp://aleph.gutenberg.org/6/6/662/old/pgw${GV}de.zip
	ftp://aleph.gutenberg.org/6/6/663/old/pgw${GV}fh.zip
	ftp://aleph.gutenberg.org/6/6/664/old/pgw${GV}il.txt
	ftp://aleph.gutenberg.org/6/6/665/old/pgw${GV}mo.zip
	ftp://aleph.gutenberg.org/6/6/666/old/pgw${GV}pq.zip
	ftp://aleph.gutenberg.org/6/6/667/old/pgw${GV}r.zip
	ftp://aleph.gutenberg.org/6/6/668/old/pgw${GV}s.zip
	ftp://aleph.gutenberg.org/6/6/669/old/pgw${GV}tw.zip
	ftp://aleph.gutenberg.org/6/7/670/old/pgw${GV}xz.zip
	https://git.sr.ht/~ag_eitilt/${SN}/archive/${SV}.tar.gz -> ${SD}.tar.gz"

LICENSE="gutenberg"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"

BDEPEND=">=app-text/dictd-1.5.5
	app-arch/unzip
	dev-libs/libxslt"

S="${WORKDIR}"

src_unpack() {
	unpack ${A//pgw${GV}il.txt}
	cp "${DISTDIR}/pgw${GV}il.txt" . || die
	cp "${SD}/xhtml-lat1.ent" "${SD}/xhtml-special.ent" "${SD}/xhtml-symbol.ent" . || die
	cp "${SD}/dictfmt-elements.txt" web1913.txt || die
}

src_prepare() {
	eapply "${SD}/tag-nesting.patch"
	eapply_user

	for f in $(ls pgw${GV}?*.txt) ; do
		echo "Cleaning '${f}'"
		sed -n -e '/<! Begin file/,$ p' -i "${f}" || die
		sed -f "${SD}/cleanup.sed" -i "${f}" || die
		(cat "${SD}/micra-head.xml" "${f}" "${SD}/micra-foot.xml" || die) > "${f%txt}xml"
	done
}

src_compile() {
	for f in $(ls pgw050?*.xml) ; do
		echo "Processing '${f}'"
		(xsltproc "${SD}/dictfmt-elements.xsl" "${f}" || die) >> web1913.txt
	done
	echo "Building dictionary"
	(dictfmt -u "https://www.gutenberg.org/ebooks/660 through ../670" \
		-s "Webster's Revised Unabridged Dictionary, 1913 edition (v${WV} ${SV})" \
		--headword-separator " / " \
		--columns 73 \
		--utf8 \
		-p web1913 \
		|| die) \
		< web1913.txt
	dictzip web1913.dict || die
}

src_install() {
	newdoc "${SD}/README" README.patches
	insinto /usr/lib/dict
	doins web1913.dict.dz web1913.index
}

pkg_postinst() {
	if [[ "${REPLACING_VERSIONS}" ]] ; then
		elog "You must restart your dictd server before the ${PN} dictionary is"
		elog "completely updated.  If you are using OpenRC, this may be accomplished by"
		elog "running '/etc/init.d/dictd restart'."
	else
		elog "You must register ${PN} and restart your dictd server before the"
		elog "dictionary is available for use.  If you are using OpenRC, both tasks may be"
		elog "accomplished by running '/etc/init.d/dictd restart'."
	fi
}

pkg_postrm() {
	if [[ ! "${REPLACED_BY_VERSION}" ]] ; then
		elog "You must unregister ${PN} and restart your dictd server before the"
		elog "dictionary is completely removed.  If you are using OpenRC, both tasks may be"
		elog "accomplished by running '/etc/init.d/dictd restart'."
	fi
}
