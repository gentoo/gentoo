# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_OPTIONAL=1
PYTHON_COMPAT=( python3_{10..11} pypy3 )

inherit bash-completion-r1 desktop distutils-r1 elisp-common flag-o-matic pax-utils toolchain-funcs xdg-utils

DESCRIPTION="Thread-based e-mail indexer, supporting quick search and tagging"
HOMEPAGE="https://notmuchmail.org/"
SRC_URI="https://notmuchmail.org/releases/${P}.tar.xz
	test? ( https://notmuchmail.org/releases/test-databases/database-v1.tar.xz )"

LICENSE="GPL-3"
# Sub-slot corresponds to major wersion of libnotmuch.so.X.Y. Bump of Y is
# meant to be binary backward compatible.
SLOT="0/5"
KEYWORDS="~alpha amd64 arm arm64 ~ppc64 ~riscv x86 ~x64-macos"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	apidoc? ( doc )
	nmbug? ( python )
	test? ( crypt emacs python )
"
IUSE="apidoc crypt doc emacs mutt nmbug python test"
RESTRICT="!test? ( test )"

BDEPEND="
	app-arch/xz-utils[extra-filters(+)]
	virtual/pkgconfig
	apidoc? (
		app-text/doxygen
		dev-lang/perl
	)
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		sys-apps/texinfo
	)
	python? (
		dev-python/setuptools[${PYTHON_USEDEP}]
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
	sys-libs/zlib:=
	emacs? ( >=app-editors/emacs-${NEED_EMACS}:* )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/cffi[${PYTHON_USEDEP}]
		' 'python*')
	)
"

DEPEND="${COMMON_DEPEND}
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
		dev-perl/Pod-Parser
	)
	nmbug? ( dev-vcs/git )
"

SITEFILE="50${PN}-gentoo.el"

PATCHES=(
	"${FILESDIR}"/${PN}-0.37-configure-clang16.patch
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

	mv contrib/notmuch-mutt/README contrib/notmuch-mutt/README-mutt || die

	# Override 'install' target, we want to install manpages with doman, but let it install texinfo files.
	sed -i "s/all install-man install-info/all $(usex doc install-info '')/" "Makefile.local" || die

	use test && append-flags '-g'

	# Non-autoconf configure
	[[ ${CHOST} == *-solaris* ]] &&	append-ldflags '-lnsl' '-lsocket'

	# sphinx-4 broke everything. https://bugs.gentoo.org/789492
	echo 'man_make_section_directory = False' >> doc/conf.py || die
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
		--zshcompletiondir="${EPREFIX}/usr/share/zsh/site-functions"
		$(use_with apidoc api-docs)
		$(use_with doc docs)
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
	# copy stuff just in case
	if use test; then
		mkdir -p build/stage/tests || die
		 cp -v tests/*.py build/stage/tests || die
	fi
	popd > /dev/null || die

	# TODO: we want to drop those, research revdeps
	pushd bindings/python > /dev/null || die
	distutils-r1_python_compile
	popd > /dev/null || die
}

python_compile_all() {
	use doc	&& emake -C bindings/python/docs html
}

src_compile() {
	python_setup # For sphinx

	# prevent race in emacs doc generation
	# FileNotFoundError: [Errno 2] No such file or directory: '..work/notmuch-0.31/emacs/notmuch.rsti'
	if use emacs; then
		use doc && emake -j1 -C emacs docstring.stamp V=1 #nowarn
	fi

	emake V=1

	use python && distutils-r1_src_compile

	if use mutt; then
		pushd contrib/notmuch-mutt > /dev/null || die
		emake notmuch-mutt.1
		popd > /dev/null || die
	fi
}

python_test() {
	# we only have tests for cffi bindings
	pushd bindings/python-cffi > /dev/null || die
	rm -f tox.ini || die
	pytest -vv || die "Tests failed with ${EPYTHON}"
	popd > /dev/null || die
}

src_test() {
	local test_failures=()
	pax-mark -m notmuch

	# we run pytest via eclass phasefunc, so delete upstream launcher
	use python && { rm -v test/T391-python-cffi.sh || die ; }

	LD_LIBRARY_PATH="${S}/lib" \
		nonfatal emake test V=1 OPTIONS="--verbose --tee" || test_failures+=( "'emake tests'" )
	pax-mark -ze notmuch

	# both lib and bin needed for testsuite.
	if use python; then
		LD_LIBRARY_PATH="${S}/lib" \
			PATH="${S}:${PATH}" \
			nonfatal distutils-r1_src_test || test_failures+=( "'python tests'" )
	fi

	[[ ${test_failures} ]] && die "Tests failed: ${test_failures[@]}"
}

python_install() {
	pushd bindings/python-cffi > /dev/null || die
	distutils-r1_python_install
	popd > /dev/null || die

	pushd bindings/python > /dev/null || die
	distutils-r1_python_install
	popd > /dev/null || die
}

src_install() {
	default

	if use doc; then
		if use apidoc; then
			# rename overly generic manpage to avoid clashes
			mv doc/_build/man/man3/deprecated.3 \
				doc/_build/man/man3/notmuch-deprecated.3 || die
		fi
		doman doc/_build/man/man?/*.?
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
		# this manpage is built by pod2man
		doman notmuch-mutt.1
		insinto /etc/mutt
		doins notmuch-mutt.rc
		dodoc README-mutt
		popd > /dev/null || die
	fi

	local DOCS=( README{,.rst} INSTALL NEWS )
	einstalldocs

	if use python; then
		use doc && local HTML_DOCS=( bindings/python/docs/html/. )
		distutils-r1_src_install
	fi
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
