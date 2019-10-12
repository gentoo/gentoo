# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

MY_PV="${PV/_beta/b}"
MY_P="${PN}-${MY_PV}"
DESCRIPTION="The VM mail reader for Emacs"
HOMEPAGE="http://www.nongnu.org/viewmail/"
SRC_URI="https://launchpad.net/vm/${PV%.*}.x/${MY_PV}/+download/${MY_P}.tgz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ppc ~ppc64 x86"
IUSE="bbdb ssl"

DEPEND="bbdb? ( app-emacs/bbdb )"
RDEPEND="${DEPEND}
	ssl? ( net-misc/stunnel )"
BDEPEND="sys-apps/texinfo"

S="${WORKDIR}/${MY_P}"
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	eapply "${FILESDIR}/${P}-datadir.patch"
	eapply "${FILESDIR}/${P}-texinfo-5.patch"
	eapply "${FILESDIR}/${P}-optional-args.patch"
	eapply_user

	if ! use bbdb; then
		elog "Excluding vm-pcrisis.el since the \"bbdb\" USE flag is not set."
		eapply "${FILESDIR}/${PN}-8.0-no-pcrisis.patch"
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
