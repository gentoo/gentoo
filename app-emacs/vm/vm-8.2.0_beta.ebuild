# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit elisp eutils

MY_PV="${PV/_beta/b}"
MY_P="${PN}-${MY_PV}"
DESCRIPTION="The VM mail reader for Emacs"
HOMEPAGE="http://www.nongnu.org/viewmail/"
SRC_URI="https://launchpad.net/vm/${PV%.*}.x/${MY_PV}/+download/${MY_P}.tgz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="bbdb ssl"

DEPEND="bbdb? ( app-emacs/bbdb )"
RDEPEND="!app-emacs/u-vm-color
	${DEPEND}
	ssl? ( net-misc/stunnel )"
DEPEND="${DEPEND}
	sys-apps/texinfo"

S="${WORKDIR}/${MY_P}"
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	epatch "${FILESDIR}/${P}-datadir.patch"
	epatch "${FILESDIR}/${P}-texinfo-5.patch"

	if ! use bbdb; then
		elog "Excluding vm-pcrisis.el since the \"bbdb\" USE flag is not set."
		epatch "${FILESDIR}/${PN}-8.0-no-pcrisis.patch"
	fi
}

src_configure() {
	econf \
		--with-emacs="emacs" \
		--with-lispdir="${SITELISP}/${PN}" \
		--with-etcdir="${SITEETC}/${PN}" \
		--with-docdir="/usr/share/doc/${PF}" \
		$(use bbdb && echo "--with-other-dirs=${SITELISP}/bbdb")
}

src_compile() {
	emake -j1
}

src_install() {
	emake -j1 DESTDIR="${D}" install
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"

	# delete duplicate documentation
	find "${D}/${SITEETC}/${PN}" -type d -name pixmaps -prune \
		-o -type f -exec rm '{}' '+' || die
	rm "${D}/usr/share/doc/${PF}/COPYING" || die

	dodoc example.vm
	# NEWS is accessed from lisp and must not be compressed
	docompress -x /usr/share/doc/${PF}/NEWS
}
