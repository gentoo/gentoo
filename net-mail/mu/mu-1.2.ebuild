# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools elisp-common

DESCRIPTION="Set of tools to deal with Maildirs, in particular, searching and indexing"
HOMEPAGE="http://www.djcbsoftware.nl/code/mu/"
SRC_URI="https://github.com/djcb/mu/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="guile emacs zsh-completion"

# net-mail/mailutils also installes /usr/bin/mu.  Block it until somebody
# really wants both installed at the same time.
DEPEND="
	!net-mail/mailutils
	dev-libs/glib:2
	dev-libs/gmime:3.0
	>=dev-libs/xapian-1.4
	emacs? ( >=virtual/emacs-24 )
	guile? ( >=dev-scheme/guile-2.2 )
	zsh-completion? ( app-shells/gentoo-zsh-completions )"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

SITEFILE="70mu-gentoo.el"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# Note: --disable-silent-rules is included in EAPI-5
	econf --disable-gtk \
		--disable-webkit \
		$(use_enable emacs mu4e) \
		$(use_enable guile)
}

src_install () {
	dobin mu/mu
	dodoc AUTHORS HACKING NEWS NEWS.org TODO README README.org ChangeLog
	doman man/mu*

	if use emacs; then
		elisp-install ${PN} mu4e/*.el mu4e/*.elc
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
		doinfo mu4e/mu4e.info
	fi

	if use guile; then
		doinfo guile/mu-guile.info
	fi

	if use zsh-completion; then
		insinto /usr/share/zsh/site-functions
		newins contrib/mu-completion.zsh _${PN}
	fi
}

src_test () {
	# Note: Fails with parallel make
	emake -j1 check
}

pkg_postinst() {
	if use emacs; then
		einfo "To use mu4e you need to configure it in your .emacs file"
		einfo "See the manual for more information:"
		einfo "http://www.djcbsoftware.nl/code/mu/mu4e/"

		elisp-site-regen
	fi

	elog "If you upgrade from an older major version,"
	elog "then you need to rebuild your mail index."
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
