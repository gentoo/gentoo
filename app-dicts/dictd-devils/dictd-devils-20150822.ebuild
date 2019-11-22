# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="The Devil's Dictionary for dict"
HOMEPAGE="http://www.dict.org/"
SRC_URI="ftp://aleph.gutenberg.org/9/7/972/972.zip -> ${P}.zip"

LICENSE="gutenberg"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"

BDEPEND=">=app-text/dictd-1.5.5
	app-arch/unzip"

S="${WORKDIR}"

src_prepare() {
	eapply "${FILESDIR}/format.patch"
	eapply_user

	sed -f "${FILESDIR}/prepare.sed" -i 972.txt || die
}

src_compile() {
	(dictfmt -u "https://www.gutenberg.org/ebooks/972" \
		-s "The Devil's Dictionary (2015-08-22 Project Gutenberg version)" \
		--headword-separator " or " \
		--columns 80 \
		-h devils \
		|| die) \
		< <(head -n -6 972.txt || die)
	sed -f "${FILESDIR}/finalize.sed" -i devils.dict || die
	dictzip devils.dict || die
}

src_install() {
	insinto /usr/lib/dict
	doins devils.dict.dz devils.index
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
