# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_OPTIONAL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

inherit bash-completion-r1 desktop distutils-r1 elisp-common flag-o-matic pax-utils toolchain-funcs xdg-utils

DESCRIPTION="Thread-based e-mail indexer, supporting quick search and tagging"
HOMEPAGE="https://notmuchmail.org/"
SRC_URI="
	https://notmuchmail.org/releases/${P}.tar.xz
	test? ( https://notmuchmail.org/releases/test-databases/database-v1.tar.xz )
"

LICENSE="GPL-3"
# Sub-slot corresponds to major wersion of libnotmuch.so.X.Y. Bump of Y is
# meant to be binary backward compatible.
SLOT="0/5"
KEYWORDS="~alpha amd64 arm arm64 ~ppc64 ~riscv x86 ~x64-macos"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	nmbug? ( python )
	test? ( crypt emacs python )
"
IUSE="apidoc crypt emacs mutt nmbug python test"
RESTRICT="!test? ( test )"

BDEPEND="
	app-arch/xz-utils[extra-filters(+)]
	dev-python/sphinx[${PYTHON_USEDEP}]
	sys-apps/texinfo
	virtual/pkgconfig
	apidoc? (
		app-text/doxygen
		dev-lang/perl
	)
	python? (
		${DISTUTILS_DEPS}
		test? ( dev-python/pytest[${PYTHON_USEDEP}] )
	)
	test? (
		app-shells/bash
		sys-process/parallel
	)
"
COMMON_DEPEND="
	dev-libs/glib
	dev-libs/gmime:3.0[crypt]
	>=dev-libs/xapian-1.4.0:=
	sys-libs/talloc
	virtual/zlib:=
	emacs? ( >=app-editors/emacs-${NEED_EMACS}:* )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/cffi[${PYTHON_USEDEP}]
		' 'python*')
	)
"
DEPEND="
	${COMMON_DEPEND}
	test? (
		>=app-editors/emacs-${NEED_EMACS}:*[libxml2]
		app-misc/dtach
		dev-debug/gdb[python]
		crypt? (
			app-crypt/gnupg
			dev-libs/openssl
		)
	)
"

RDEPEND="
	${COMMON_DEPEND}
	crypt? ( app-crypt/gnupg )
	mutt? (
		dev-perl/File-Which
		dev-perl/Mail-Box
		dev-perl/MailTools
		dev-perl/Term-ReadLine-Gnu
		virtual/perl-Digest-SHA
		virtual/perl-File-Path
		virtual/perl-Getopt-Long
		dev-perl/Pod-Parser
	)
	nmbug? ( dev-vcs/git )
"

SITEFILE="50${PN}-gentoo.el"

PATCHES=(
	"${FILESDIR}"/${PN}-0.39-no-compress-man-pages.patch
	"${FILESDIR}"/${PN}-0.39-test-skip-debug-symbols.patch
)

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
	default

	use python && distutils-r1_src_prepare

	rm bindings/python-cffi/tox.ini || die
	mv contrib/notmuch-mutt/README contrib/notmuch-mutt/README-mutt || die

	# Non-autoconf configure
	[[ ${CHOST} == *-solaris* ]] &&	append-ldflags '-lnsl' '-lsocket'
}

src_configure() {
	python_setup # For sphinx

	tc-export CC CXX

	local myconf=(
		--bashcompletiondir="$(get_bashcompdir)"
		--emacslispdir="${EPREFIX}/${SITELISP}/${PN}"
		--emacsetcdir="${EPREFIX}/${SITEETC}/${PN}"
		--without-desktop
		--without-ruby
		--with-docs # man pages, info pages
		--zshcompletiondir="${EPREFIX}/usr/share/zsh/site-functions"
		$(use_with apidoc api-docs)
		$(use_with emacs)
	)

	# FIXME:
	# Checking for GMime session key extraction support... * ACCESS DENIED: open_wr: /dev/bus/usb/001/011
	# notmuch configure compiles a program _check_session_keys.c, inline in ./configure script
	# gmime/gpg/scdaemon tries to open usb devices in GMime test
	# we pretend to allow it, without actually allowing it to read or write.
	# https://bugs.gentoo.org/821328
	addpredict /dev/bus/usb

	econf "${myconf[@]}"
}

python_compile() {
	pushd bindings/python-cffi > /dev/null || die
	distutils-r1_python_compile
	popd > /dev/null || die
}

src_compile() {
	emake V=1
	use python && distutils-r1_src_compile
	use mutt && emake -C contrib/notmuch-mutt notmuch-mutt.1
}

python_test() {
	pushd bindings/python-cffi > /dev/null || die
	rm -rf notmuch2 || die
	epytest tests || die -n
	popd > /dev/null || die
}

src_test() {
	local test_failures=()

	# We run pytest via eclass phasefunc, so delete upstream launcher
	rm test/T391-python-cffi.sh || die

	# These both fail because of line wrapping in the output
	rm test/T315-emacs-tagging.sh test/T310-emacs.sh || die

	pax-mark -m notmuch
	LD_LIBRARY_PATH="${S}/lib" nonfatal emake test \
		V=1 \
		OPTIONS="--verbose --tee" || test_failures+=( "'emake tests'" )
	pax-mark -ze notmuch

	# Both lib and bin needed for testsuite
	if use python; then
		LD_LIBRARY_PATH="${S}/lib" \
			PATH="${S}:${PATH}" \
			nonfatal distutils-r1_src_test || test_failures+=( "'python tests'" )
	fi

	[[ ${test_failures} ]] && die "Tests failed: ${test_failures[*]}"
}

python_install() {
	pushd bindings/python-cffi > /dev/null || die
	distutils-r1_python_install
	popd > /dev/null || die
}

src_install() {
	default

	use python && distutils-r1_src_install

	if use apidoc; then
		# Rename overly generic manpage to avoid clashes
		mv doc/_build/man/man3/deprecated.3 \
			doc/_build/man/man3/notmuch-deprecated.3 || die
	fi

	if use emacs; then
		elisp-site-file-install "${FILESDIR}/${SITEFILE}" || die
		domenu emacs/notmuch-emacs-mua.desktop
	fi

	if use nmbug; then
		# TODO: those guys need proper deps
		python_fix_shebang devel/nmbug/notmuch-report
		dobin devel/nmbug/notmuch-report
	fi

	if use mutt; then
		pushd contrib/notmuch-mutt > /dev/null || die
		dobin notmuch-mutt
		# This manpage is built by pod2man
		doman notmuch-mutt.1
		insinto /etc/mutt
		doins notmuch-mutt.rc
		dodoc README-mutt
		popd > /dev/null || die
	fi

	local DOCS=( README{,.rst} INSTALL NEWS )
	einstalldocs
}

pkg_preinst() {
	local _rcfile="/etc/mutt/notmuch-mutt.rc"
	if use mutt && ! [[ -e "${EROOT}"${_rcfile} ]]; then
		elog "To enable notmuch support in mutt, add the following line"
		elog "to your mutt config file:"
		elog ""
		elog "  source ${_rcfile}"
	fi
}

pkg_postinst() {
	if use emacs; then
		elisp-site-regen
		xdg_desktop_database_update
	fi
}

pkg_postrm() {
	if use emacs; then
		elisp-site-regen
		xdg_desktop_database_update
	fi
}
