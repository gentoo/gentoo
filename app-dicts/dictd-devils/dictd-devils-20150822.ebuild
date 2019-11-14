# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="The Devil's Dictionary for dict"
HOMEPAGE="http://www.dict.org/"
SRC_FILE="http://www.gutenberg.org/files/972/972.zip"
SRC_URI="${SRC_FILE} -> ${P}.zip"

LICENSE="public-domain"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"

BDEPEND=">=app-text/dictd-1.5.5
	app-arch/unzip"

S="${WORKDIR}"

src_prepare() {
	eapply "${FILESDIR}/format.patch"
	eapply_user

	sed -e 's/\r//g' -i 972.txt
	sed -e "/^ *THE DEVIL'S DICTIONARY/,/^End of Project Gutenberg's The Devil's Dictionary/!{w COPYING.gutenberg" -e 'd}' -i 972.txt
	sed -e '/^\S/{: l;N;s/\n *\(.\)/ \1/g;t l}' -i 972.txt
	sed -e "s/^\\([A-Zor .'?-]*[^,A-Zor .'?-]\\)/ \1/" -i 972.txt
	sed -e '/^ /y/,/\a/' -i 972.txt
}

src_compile() {
	head -n -6 972.txt | \
		dictfmt -u "${SRC_FILE}" \
		-s "The Devil's Dictionary (2015-08-22 Project Gutenberg version)" \
		--headword-separator " or " \
		--columns 80 \
		-h devils
	sed -e 'y/\a/,/' -i devils.dict
	dictzip devils.dict
}

src_install() {
	dodoc COPYING.gutenberg
	insinto /usr/lib/dict
	doins devils.dict.dz devils.index || die
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
