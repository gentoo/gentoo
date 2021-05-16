# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_OPTIONAL=1
NEED_EMACS="24.1"
PYTHON_COMPAT=( python3_{7,8,9} )

inherit bash-completion-r1 distutils-r1 elisp-common eutils flag-o-matic \
	pax-utils toolchain-funcs

DESCRIPTION="Thread-based e-mail indexer, supporting quick search and tagging"
HOMEPAGE="https://notmuchmail.org/"
SRC_URI="https://notmuchmail.org/releases/${P}.tar.xz
	test? ( https://notmuchmail.org/releases/test-databases/database-v1.tar.xz )"

LICENSE="GPL-3"
# Sub-slot corresponds to major wersion of libnotmuch.so.X.Y. Bump of Y is
# meant to be binary backward compatible.
SLOT="0/5"
KEYWORDS="~alpha amd64 ~arm64 ~ppc64 x86"
REQUIRED_USE="
	nmbug? ( python )
	python? ( ${PYTHON_REQUIRED_USE} )
	test? ( crypt emacs python valgrind )
"
IUSE="crypt doc emacs mutt nmbug python test valgrind"
RESTRICT="!test? ( test )"

BDEPEND="
	virtual/pkgconfig
	doc? (
		app-doc/doxygen
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/sphinx
		sys-apps/texinfo
	)
"
COMMON_DEPEND="
	dev-libs/glib
	dev-libs/gmime:3.0[crypt]
	>=dev-libs/xapian-1.4.14:=
	sys-libs/talloc
	sys-libs/zlib
	emacs? ( >=app-editors/emacs-${NEED_EMACS}:* )
	python? (
		${PYTHON_DEPS}
		dev-python/cffi
	)
"
DEPEND="${COMMON_DEPEND}
	test? (
		>=app-editors/emacs-${NEED_EMACS}:*[libxml2]
		app-misc/dtach
		sys-devel/gdb
		crypt? (
			app-crypt/gnupg
			dev-libs/openssl
		)
	)
	valgrind? ( dev-util/valgrind )
"
RDEPEND="${COMMON_DEPEND}
	crypt? ( app-crypt/gnupg )
	mutt? (
		dev-perl/File-Which
		dev-perl/Mail-Box
		dev-perl/MailTools
		dev-perl/String-ShellQuote
		dev-perl/Term-ReadLine-Gnu
		virtual/perl-Digest-SHA
		virtual/perl-File-Path
		virtual/perl-Getopt-Long
		virtual/perl-Pod-Parser
	)
	nmbug? ( dev-vcs/git )
"

DOCS=( AUTHORS NEWS README )
SITEFILE="50${PN}-gentoo.el"

bindings() {
	local rc=0
	if use python; then
		pushd bindings/python-cffi || die
		${@}
		rc=${?}
		popd || die

		# Old deprecated bindings, #736204
		pushd bindings/python || die
		${@}
		rc=${?}
		popd || die
	fi
	return ${rc}
}

pkg_setup() {
	use emacs && elisp-check-emacs-version
}

src_unpack() {
	unpack "${P}".tar.xz
	if use test; then
		mkdir -p "${S}"/test/test-databases || die
		cp "${DISTDIR}"/database-v1.tar.xz "${S}"/test/test-databases/ || die
	fi
}

src_prepare() {
	local _deps=""
	default

	# Python bindings
	bindings distutils-r1_src_prepare
	mv contrib/notmuch-mutt/README contrib/notmuch-mutt/README-mutt || die

	# Override dependencies for 'install' target
	use doc && _deps="install-info"
	sed -e "s/^install:.\+/install: all ${_deps}/" -i Makefile.local || die

	if use test; then
		append-cflags -g
		append-cxxflags -g
	fi

	if [[ ${CHOST} == *-solaris* ]] ; then
		# Non-autoconf configure
		append-ldflags -lnsl -lsocket
	fi
}

src_configure() {
	python_setup # For sphinx
	local _args=(
		--bashcompletiondir="$(get_bashcompdir)"
		--emacslispdir="${EPREFIX}/${SITELISP}/${PN}"
		--emacsetcdir="${EPREFIX}/${SITEETC}/${PN}"
		--without-desktop
		--without-ruby
		--zshcompletiondir="${EPREFIX}/usr/share/zsh/site-functions"
		$(use_with emacs)
		$(use_with doc api-docs)
	)
	tc-export CC CXX
	econf "${_args[@]}"
}

src_compile() {
	python_setup # For sphinx
	V=1 default
	bindings distutils-r1_src_compile

	if use mutt; then
		pushd contrib/notmuch-mutt || die
		emake notmuch-mutt.1
		popd || die
	fi
}

src_test() {
	pax-mark -m notmuch
	LD_LIBRARY_PATH="${WORKDIR}/${P}/lib" V=1 default
	pax-mark -ze notmuch
}

src_install() {
	default

	if use doc; then
		doman doc/_build/man/man?/*.?
	fi

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

	DOCS="" bindings distutils-r1_src_install
}

pkg_preinst() {
	local _rcfile="/etc/mutt/notmuch-mutt.rc"
	if use mutt && ! [[ -e ${ROOT}${_rcfile} ]]; then
		elog "To enable notmuch support in mutt, add the following line"
		elog "to your mutt config file:"
		elog ""
		elog "  source ${_rcfile}"
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
