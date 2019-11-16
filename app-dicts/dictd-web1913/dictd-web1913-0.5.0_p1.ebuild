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
SRC_FILES="http://www.gutenberg.org/files/660/old/pgw${GV}ab.zip
	http://www.gutenberg.org/files/661/old/pgw${GV}c.zip
	http://www.gutenberg.org/files/662/old/pgw${GV}de.zip
	http://www.gutenberg.org/files/663/old/pgw${GV}fh.zip
	http://www.gutenberg.org/files/664/old/pgw${GV}il.txt
	http://www.gutenberg.org/files/665/old/pgw${GV}mo.zip
	http://www.gutenberg.org/files/666/old/pgw${GV}pq.zip
	http://www.gutenberg.org/files/667/old/pgw${GV}r.zip
	http://www.gutenberg.org/files/668/old/pgw${GV}s.zip
	http://www.gutenberg.org/files/669/old/pgw${GV}tw.zip
	http://www.gutenberg.org/files/670/old/pgw${GV}xz.zip"
SRC_URI="${SRC_FILES}
	https://git.sr.ht/~ag_eitilt/${SN}/archive/${SV}.tar.gz -> ${SD}.tar.gz"

LICENSE="public-domain"
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

	(sed -e '/<! Begin file/,$ d' pgw050c.txt || die) > COPYING.gutenberg

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
	(dictfmt -u " ${SRC_FILES}" \
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
	dodoc COPYING.gutenberg "${SD}/README"
	newdoc "${SD}/dictfmt-elements.txt" COPYING.micra
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
