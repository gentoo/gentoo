# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
inherit autotools elisp-common flag-o-matic python-single-r1

DESCRIPTION="Tag system to find an object location in various sources"
HOMEPAGE="https://www.gnu.org/software/global/global.html"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc emacs"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	dev-libs/libltdl
	dev-db/sqlite
	sys-libs/ncurses
	$(python_gen_cond_dep '
		dev-python/pygments[${PYTHON_USEDEP}]
	')
	emacs? ( >=app-editors/emacs-23.1:* )
"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? (
		app-text/texi2html
		app-text/texlive-core
		sys-apps/texinfo
	)
"

SITEFILE="50gtags-gentoo.el"

PATCHES=(
	"${FILESDIR}/${PN}-6.2.9-tinfo.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# bug #943798
	append-cflags -std=gnu17

	local myeconfargs=(
		--with-python-interpreter="${PYTHON}"
		--with-sqlite3 # avoid using bundled copy
		$(use_with emacs lispdir "${SITELISP}/${PN}")
	)

	econf "${myeconfargs[@]}"
}

src_compile() {
	if use doc; then
		texi2pdf -q -o doc/global.pdf doc/global.texi || die
		texi2html -o doc/global.html doc/global.texi || die
	fi

	if use emacs; then
		elisp-compile *.el
	fi

	emake
}

src_install() {
	default

	rm -rf "${ED}"/var/lib || die

	insinto /etc
	doins gtags.conf

	insinto /usr/share/vim/vimfiles/plugin
	doins gtags.vim

	if use emacs; then
		elisp-install ${PN} *.{el,elc}
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi

	if use doc; then
		# doc/global.pdf is generated if tex executable (e.g. /usr/bin/tex) is available.
		[[ -f doc/global.pdf ]] && DOCS+=( doc/global.pdf )
	fi

	find "${ED}" -name '*.la' -type f -delete || die
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
