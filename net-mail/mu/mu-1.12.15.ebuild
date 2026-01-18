# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp-common meson readme.gentoo-r1

DESCRIPTION="Set of tools to deal with Maildirs, in particular, searching and indexing"
HOMEPAGE="https://www.djcbsoftware.nl/code/mu/ https://github.com/djcb/mu"
SRC_URI="https://github.com/djcb/mu/releases/download/v${PV}/${P}.tar.xz"

# mu: GPL-3+
# + tl: CC0-1.0
# + variant-lite: Boost-1.0
LICENSE="BSD Boost-1.0 CC0-1.0 GPL-3+ MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86 ~x64-macos"
IUSE="emacs readline test"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-cpp/cli11-2.4
	dev-libs/glib:2
	>=dev-libs/gmime-3.2:3.0
	>=dev-libs/libfmt-11.1:=
	>=dev-libs/xapian-1.4:=
	emacs? ( >=app-editors/emacs-25.3:* )
	readline? ( sys-libs/readline:= )
"
RDEPEND="${DEPEND}"
BDEPEND="
	sys-apps/texinfo
	virtual/pkgconfig
"

PATCHES=(
	# https://bugs.gentoo.org/925503
	"${FILESDIR}"/${PN}-1.12.0-no-python.patch
)

DOC_CONTENTS="
	To use mu4e you need to configure it in your .emacs file.
	See the manual for more information:
	https://www.djcbsoftware.nl/code/mu/mu4e/
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
		$(meson_feature test tests)
		-Dcld2=disabled
		-Demacs="$(usex emacs "${EMACS}" emacs-not-enabled)"
		# TODO: revisit this, it's not actually deprecated, just been reworked
		-Dguile=disabled
		-Dscm=disabled
		-Duse-embedded-fmt=false
		-Duse-embedded-cli11=false
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

	if use emacs; then
		# Same as above.
		docompress -x /usr/share/doc/${PF}/mu4e-about.org
		dodoc mu4e/mu4e-about.org

		elisp-site-file-install "${FILESDIR}"/${SITEFILE}

		readme.gentoo_create_doc
	fi
}

pkg_postinst() {
	use emacs && readme.gentoo_create_doc
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
