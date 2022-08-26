# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp-common meson

DESCRIPTION="Set of tools to deal with Maildirs, in particular, searching and indexing"
HOMEPAGE="https://www.djcbsoftware.nl/code/mu/ https://github.com/djcb/mu"
SRC_URI="https://github.com/djcb/mu/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~riscv x86 ~x64-macos"
IUSE="emacs readline"

DEPEND="
	dev-libs/glib:2
	dev-libs/gmime:3.0
	>=dev-libs/xapian-1.4:=
	emacs? ( >=app-editors/emacs-25.3:* )
	readline? ( sys-libs/readline:= )"
RDEPEND="${DEPEND}"
BDEPEND="
	sys-apps/texinfo
	virtual/pkgconfig
"

SITEFILE="70mu-gentoo-autoload.el"

src_prepare() {
	default

	# Don't install NEWS.org into /usr/share/doc.
	sed -i '/NEWS.org/,+1 d' meson.build || die
	sed -i '/mu4e-about.org/d' mu4e/meson.build || die

	# Don't compress the info file.
	sed -i '/gzip/d' build-aux/meson-install-info.sh || die

	# Instead, put it in /usr/share/doc/${PF}.
	sed -i "/MU_DOC_DIR/s/mu/${PF}/" mu4e/meson.build || die
}

src_configure() {
	local emesonargs=(
		$(meson_feature readline)
		-Demacs="$(usex emacs "${EMACS}" emacs-not-enabled)"
		# NOTE: Guile interface is deprecated to be removed shortly.
		-Dguile=disabled
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	# Since meson no longer installs NEWS.org, install it with dodoc.
	# Also, it must be uncompressed so that it can be viewed with
	# mu4e-info.
	docompress -x /usr/share/doc/${PF}/NEWS.org
	dodoc NEWS.org

	# Same as above.
	docompress -x /usr/share/doc/${PF}/mu4e-about.org
	dodoc mu4e/mu4e-about.org
}

pkg_preinst() {
	if [[ -n ${REPLACING_VERSIONS} ]]; then
		elog "After upgrading from an old major version, you should"
		elog "rebuild your mail index."
	fi
}

pkg_postinst() {
	if use emacs; then
		einfo "To use mu4e you need to configure it in your .emacs file"
		einfo "See the manual for more information:"
		einfo "https://www.djcbsoftware.nl/code/mu/mu4e/"

		elisp-site-regen
	fi
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
