# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="The Jargon File for dict"
HOMEPAGE="http://www.catb.org/~esr/jargon/index.html"
SRC_FILE="http://www.catb.org/~esr/jargon/oldversions/jarg${PV//.}.txt"
SRC_URI="${SRC_FILE}"

LICENSE="public-domain"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"

DEPEND=">=app-text/dictd-1.5.5"

S="${WORKDIR}"

src_unpack() {
	cp "${DISTDIR}/${A}" jargon.txt || die
}

src_prepare() {
	eapply_user
	# This sed script works for all versions >=3.0.0 until <4.4.0 (when the
	# entire format changes).
	sed -f "${FILESDIR}/prepare.sed" -i jargon.txt || die
}

src_compile() {
	(dictfmt -u "${SRC_FILE}" \
		-s "The Jargon File (version ${PV})" \
		--columns 80 \
		-j jargon \
		|| die) \
		< jargon.txt
	dictzip jargon.dict || die
}

src_install() {
	newdoc jargon.doc jargon.txt
	insinto /usr/lib/dict
	doins jargon.dict.dz jargon.index
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
