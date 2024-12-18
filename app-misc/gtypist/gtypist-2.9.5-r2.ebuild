# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp-common autotools

DESCRIPTION="Universal typing tutor"
HOMEPAGE="https://www.gnu.org/software/gtypist/"
SRC_URI="
	mirror://gnu/gtypist/${P}.tar.xz
	http://colemak.com/pub/learn/colemak.typ
"

LICENSE="GPL-2 public-domain"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc ~riscv x86 ~amd64-linux"
IUSE="nls emacs xemacs"

DEPEND="
	>=sys-libs/ncurses-5.2:0=
	emacs? ( >=app-editors/emacs-23.1:* )
	xemacs? ( !emacs? ( app-editors/xemacs app-xemacs/fsf-compat ) )
"
RDEPEND="${DEPEND}"

SITEFILE=50${PN}-gentoo.el

src_unpack() {
	unpack ${P}.tar.xz
}

PATCHES=(
	"${FILESDIR}"/${PN}-2.8.3-xemacs-compat.patch

	# solution from https://bugs.gentoo.org/698764#c0
	"${FILESDIR}"/${PN}-2.9.5-link-infow.patch

	# Last release was 10 years ago but many commits in git since,
	# looks fixed there but not backportable.
	"${FILESDIR}"/${PN}-2.9.5-c99.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local lispdir=""
	if use emacs; then
		lispdir="${SITELISP}/${PN}"
		einfo "Configuring to build with GNU Emacs support"
	elif use xemacs; then
		lispdir="${EPREFIX}/usr/lib/xemacs/site-packages/lisp/${PN}"
		einfo "Configuring to build with XEmacs support"
	fi

	econf \
		$(use_enable nls) \
		EMACS=$(usev emacs || usev xemacs || echo no) \
		--with-lispdir="${lispdir}"
}

DOCS=( AUTHORS ChangeLog NEWS README THANKS TODO )

src_install() {
	default

	insinto /usr/share/gtypist
	doins "${DISTDIR}"/colemak.typ

	if use emacs; then
		elisp-site-file-install "${FILESDIR}/${SITEFILE}" || die
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
