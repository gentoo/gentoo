# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit readme.gentoo-r1

DESCRIPTION="A small Jabber console client with various features, like MUC, SSL, PGP"
HOMEPAGE="http://mcabber.com/"

if [[ "${PV}" == 9999 ]]; then
	inherit mercurial
	EHG_REPO_URI="https://bitbucket.org/McKael/mcabber"
	EHG_CHECKOUT_DIR="${WORKDIR}"
	EHG_BOOTSTRAP="autogen.sh"
	S="${WORKDIR}/${PN}"
else
	SRC_URI="http://mcabber.com/files/${P}.tar.bz2"
	SRC_URI+=" https://dev.gentoo.org/~andrey_utkin/distfiles/${P}_bug699972.patch"
	KEYWORDS="~alpha ~amd64 ~arm ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
fi

LICENSE="GPL-2"
SLOT="0"

IUSE="aspell crypt idn otr spell ssl vim-syntax"

LANGS="cs de fr it nl pl ru uk"
# localized help versions are installed only, when L10N var is set
for i in ${LANGS}; do
	IUSE="${IUSE} l10n_${i}"
done;

RDEPEND="crypt? ( >=app-crypt/gpgme-1.0.0 )
	otr? ( >=net-libs/libotr-3.1.0 )
	aspell? ( app-text/aspell )
	vim-syntax? ( || ( app-editors/vim app-editors/gvim ) )
	idn? ( net-dns/libidn:= )
	spell? ( app-text/enchant )
	dev-libs/glib:2
	net-libs/libnsl:0=
	sys-libs/ncurses:0=
	>=net-libs/loudmouth-1.4.3-r1[ssl?]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

# only for patching 1.1.0 release, don't port to later ebuilds
DEPEND+=" sys-devel/automake:1.14"

DOCS=( AUTHORS ChangeLog NEWS README TODO mcabberrc.example doc/README_PGP.txt )

PATCHES=(
	"${DISTDIR}/${P}_bug699972.patch"
)

pkg_setup() {
	if use aspell && use spell; then
		ewarn "NOTE: You have both USE flags 'aspell' and 'spell' enabled, enchant (USE flag 'spell') will be preferred."
	fi
}

src_configure() {
	econf \
		--enable-modules \
		$(use_enable crypt gpgme) \
		$(use_enable otr) \
		$(use_enable aspell) \
		$(use_enable spell enchant) \
		$(use_with idn libidn)
}

src_install() {
	default

	# clean unneeded language documentation
	for i in ${LANGS}; do
		use l10n_${i} || rm -rf "${ED}"/usr/share/${PN}/help/${i}
	done

	# contrib themes
	insinto /usr/share/${PN}/themes
	doins "${S}"/contrib/themes/*

	# contrib generic scripts
	exeinto /usr/share/${PN}/scripts
	doexe "${S}"/contrib/*.{pl,py}

	# contrib event scripts
	exeinto /usr/share/${PN}/scripts/events
	doexe "${S}"/contrib/events/*

	if use vim-syntax; then
		cd contrib/vim/ || die

		insinto /usr/share/vim/vimfiles/syntax
		doins mcabber_log-syntax.vim

		insinto /usr/share/vim/vimfiles/ftdetect
		doins mcabber_log-ftdetect.vim
	fi

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
