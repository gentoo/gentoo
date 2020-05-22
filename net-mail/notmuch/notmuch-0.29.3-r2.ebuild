# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_OPTIONAL=1
NEED_EMACS="24.1"
PYTHON_COMPAT=( python3_{6,7} )

inherit bash-completion-r1 distutils-r1 elisp-common eutils flag-o-matic \
	pax-utils readme.gentoo-r1 toolchain-funcs

DESCRIPTION="Thread-based e-mail indexer, supporting quick search and tagging"
HOMEPAGE="https://notmuchmail.org/"
SRC_URI="https://notmuchmail.org/releases/${P}.tar.xz
	test? ( https://notmuchmail.org/releases/test-databases/database-v1.tar.xz )"

LICENSE="GPL-3"
# Sub-slot corresponds to major wersion of libnotmuch.so.X.Y. Bump of Y is
# meant to be binary backward compatible.
SLOT="0/5"
KEYWORDS="~alpha ~amd64 ~ppc64 ~x86 ~x64-solaris"
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
CDEPEND="
	dev-libs/glib
	dev-libs/gmime:3.0[crypt]
	>=dev-libs/xapian-1.4.8:=
	sys-libs/talloc
	sys-libs/zlib
	emacs? ( >=app-editors/emacs-${NEED_EMACS}:* )
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${CDEPEND}
	test? (
		>=app-editors/emacs-${NEED_EMACS}:*[libxml2]
		app-misc/dtach
		sys-devel/gdb
		crypt? ( app-crypt/gnupg dev-libs/openssl )
	)
	valgrind? ( dev-util/valgrind )
"
RDEPEND="${CDEPEND}
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
DOC_CONTENTS="There are a few backward-incompatible changes between
notmuch version 0.18 < x <= 0.18. Please consult the NEWS file (0.18
section) before first use."
MY_LD_LIBRARY_PATH="${WORKDIR}/${P}/lib"
PATCHES=(
	"${FILESDIR}/${PV}-0001-Use-loopback-IP-address-rather-than-name.patch"
)
SITEFILE="50${PN}-gentoo.el"

bindings() {
	local rc=0
	if use $1; then
		pushd bindings/$1 || die
		shift
		"$@"
		rc=$?
		popd || die
	fi
	return $rc
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
	bindings python distutils-r1_src_prepare
	bindings python mv README README-python || die
	mv contrib/notmuch-mutt/README contrib/notmuch-mutt/README-mutt || die

	# Ensure that a new Makefile.config will be generated
	rm -f Makefile.config || die

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

	DOCS="" bindings python distutils-r1_src_install
	use doc && bindings python dodoc -r html
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
	if has_version '<net-mail/notmuch-0.18'; then
		FORCE_PRINT_ELOG=1 readme.gentoo_print_elog
	fi
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
