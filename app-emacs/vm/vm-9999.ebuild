# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp bzr autotools

DESCRIPTION="The VM mail reader for Emacs"
HOMEPAGE="http://www.nongnu.org/viewmail/"
EBZR_REPO_URI="lp:vm"

LICENSE="GPL-2+"
SLOT="0"
IUSE="bbdb ssl"

BDEPEND="bbdb? ( app-emacs/bbdb )"
RDEPEND="${BDEPEND}
	ssl? ( net-misc/stunnel )"
BDEPEND="${BDEPEND}
	sys-apps/texinfo"

SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	eapply "${FILESDIR}"/vm-8.2.0_beta-texinfo-encoding.patch
	if ! use bbdb; then
		elog "Excluding vm-pcrisis.el since the \"bbdb\" USE flag is not set."
		eapply "${FILESDIR}/${PN}-8.0-no-pcrisis.patch"
	fi
	eapply_user
	eautoreconf
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

	dodoc example.vm
	# NEWS is accessed from lisp and must not be compressed
	docompress -x /usr/share/doc/${PF}/NEWS
}
