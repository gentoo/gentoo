# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DISTUTILS_OPTIONAL=1
PYTHON_COMPAT=( python2_7 )

inherit bash-completion-r1 elisp-common eutils flag-o-matic pax-utils \
	distutils-r1 toolchain-funcs

DESCRIPTION="Thread-based e-mail indexer, supporting quick search and tagging"
HOMEPAGE="https://notmuchmail.org/"
SRC_URI="${HOMEPAGE%/}/releases/${P}.tar.gz
	test? ( ${HOMEPAGE%/}/releases/test-databases/database-v1.tar.xz )"

LICENSE="GPL-3"
# Sub-slot corresponds to major wersion of libnotmuch.so.X.Y.  Bump of Y is
# meant to be binary backward compatible.
SLOT="0/4"
KEYWORDS="~alpha amd64 x86"
REQUIRED_USE="
	nmbug? ( python )
	python? ( ${PYTHON_REQUIRED_USE} )
	test? ( crypt emacs python valgrind )
	"
IUSE="crypt doc emacs mutt nmbug python test valgrind"

CDEPEND="
	!!<app-shells/bash-completion-1.9
	>=dev-libs/glib-2.22:2
	>=dev-libs/gmime-2.6.20-r2:2.6
	>=dev-libs/xapian-1.2.7-r2:=
	dev-python/sphinx[${PYTHON_USEDEP}]
	>=sys-libs/zlib-1.2.5.2
	sys-libs/talloc
	crypt? ( >=dev-libs/gmime-2.6.20-r2:2.6[smime] )
	emacs? ( >=virtual/emacs-23 )
	python? ( ${PYTHON_DEPS} )
	"
DEPEND="${CDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	test? ( app-misc/dtach || ( >=app-editors/emacs-23[libxml2]
		>=app-editors/emacs-vcs-23[libxml2] ) sys-devel/gdb
		crypt? ( app-crypt/gnupg dev-libs/openssl ) )
	valgrind? ( dev-util/valgrind )
	"
RDEPEND="${CDEPEND}
	crypt? ( app-crypt/gnupg )
	nmbug? ( dev-vcs/git )
	mutt? ( dev-perl/File-Which dev-perl/Mail-Box dev-perl/MailTools
		dev-perl/String-ShellQuote dev-perl/Term-ReadLine-Gnu
		virtual/perl-Digest-SHA virtual/perl-File-Path virtual/perl-Getopt-Long
		virtual/perl-Pod-Parser )
	"

DOCS=( AUTHORS NEWS README )
SITEFILE="50${PN}-gentoo.el"
MY_LD_LIBRARY_PATH="${WORKDIR}/${P}/lib"

bindings() {
	local ret=0

	if use $1; then
		pushd bindings/$1 || die
		shift
		"$@"
		ret=$?
		popd || die
	fi

	return $ret
}

pkg_pretend() {
	if has_version '<net-mail/notmuch-0.18'; then
		ewarn
		ewarn "There are few not backward compatible changes between"
		ewarn "<notmuch-0.18 and >=notmuch-0.18.  See NEWS file"
		ewarn "(0.18 section) for details before first use!"
		ewarn
	fi
}

pkg_setup() {
	if use emacs; then
		elisp-need-emacs 23 || die "Emacs version too low"
	fi
}

src_unpack() {
	unpack "${P}".tar.gz
	if use test; then
		mkdir -p "${S}"/test/test-databases || die
		cp "${DISTDIR}"/database-v1.tar.xz "${S}"/test/test-databases/ || die
	fi
}

src_prepare() {
	default

	bindings python distutils-r1_src_prepare
	bindings python mv README README-python || die
	mv contrib/notmuch-mutt/README contrib/notmuch-mutt/README-mutt || die

	# assure that new Makefile.config will be generated
	rm -f Makefile.config || die

	if use test; then
		append-cflags -g
		append-cxxflags -g
	fi
}

src_configure() {
	local myeconfargs=(
		--bashcompletiondir="$(get_bashcompdir)"
		--emacslispdir="${EPREFIX}/${SITELISP}/${PN}"
		--emacsetcdir="${EPREFIX}/${SITEETC}/${PN}"
		--without-ruby
		--zshcompletiondir="${EPREFIX}/usr/share/zsh/site-functions"
		$(use_with emacs)
		$(use_with doc api-docs)
	)
	tc-export CC CXX
	econf "${myeconfargs[@]}"
}

src_compile() {
	V=1 default
	bindings python distutils-r1_src_compile

	if use mutt; then
		pushd contrib/notmuch-mutt || die
		emake notmuch-mutt.1
		popd || die
	fi

	if use doc; then
		pydocs() {
			pushd docs || die
			emake html
			rm -r html/_sources || die
			rm html/{objects.inv,.buildinfo} || die
			mkdir -p ../html && mv html ../html/python || die
			popd || die
		}
		LD_LIBRARY_PATH="${MY_LD_LIBRARY_PATH}" bindings python pydocs
	fi
}

src_test() {
	pax-mark -m notmuch
	LD_LIBRARY_PATH="${MY_LD_LIBRARY_PATH}" V=1 default
	pax-mark -ze notmuch
}

src_install() {
	default

	if use emacs; then
		elisp-site-file-install "${FILESDIR}/${SITEFILE}" || die
	fi

	if use nmbug; then
		dobin devel/nmbug/nmbug
		dobin devel/nmbug/notmuch-report
	fi

	if use mutt; then
		pushd contrib/notmuch-mutt || die
		dobin notmuch-mutt
		doman notmuch-mutt.1
		insinto /etc/mutt
		doins notmuch-mutt.rc
		dodoc README-mutt
		popd || die
	fi

	DOCS="" bindings python distutils-r1_src_install
	use doc && bindings python dodoc -r html
}

pkg_preinst() {
	if use mutt && ! [[ -e ${ROOT}/etc/mutt/notmuch-mutt.rc ]]; then
		elog "To enable notmuch support in mutt, add the following line into"
		elog "your mutt config file, please:"
		elog ""
		elog "  source /etc/mutt/notmuch-mutt.rc"
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
