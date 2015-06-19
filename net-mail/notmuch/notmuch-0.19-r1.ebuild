# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/notmuch/notmuch-0.19-r1.ebuild,v 1.4 2015/04/08 18:18:33 mgorny Exp $

EAPI=5

DISTUTILS_OPTIONAL=1
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit bash-completion-r1 elisp-common eutils flag-o-matic pax-utils \
	distutils-r1 toolchain-funcs

DESCRIPTION="Thread-based e-mail indexer, supporting quick search and tagging"
HOMEPAGE="http://notmuchmail.org/"
SRC_URI="${HOMEPAGE%/}/releases/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
REQUIRED_USE="
	nmbug? ( python )
	python? ( ${PYTHON_REQUIRED_USE} )
	test? ( crypt debug emacs python )
	"
IUSE="crypt debug doc emacs mutt nmbug python test"

CDEPEND="
	>=app-shells/bash-completion-1.9
	>=dev-libs/glib-2.22
	>=dev-libs/gmime-2.6.7
	!=dev-libs/gmime-2.6.19
	<dev-libs/xapian-1.3
	>=sys-libs/zlib-1.2.5.2
	sys-libs/talloc
	debug? ( dev-util/valgrind )
	emacs? ( >=virtual/emacs-23 )
	python? ( ${PYTHON_DEPS} )
	x86? ( >=dev-libs/xapian-1.2.7-r2 )
	"
DEPEND="${CDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen
		python? ( dev-python/sphinx[${PYTHON_USEDEP}] ) )
	test? ( app-misc/dtach || ( >=app-editors/emacs-23[libxml2]
		>=app-editors/emacs-vcs-23[libxml2] ) sys-devel/gdb )
	"
RDEPEND="${CDEPEND}
	crypt? ( app-crypt/gnupg )
	nmbug? ( dev-vcs/git )
	mutt? ( dev-perl/File-Which dev-perl/Mail-Box dev-perl/MailTools
		dev-perl/String-ShellQuote dev-perl/Term-ReadLine-Gnu
		virtual/perl-Digest-SHA virtual/perl-File-Path virtual/perl-Getopt-Long
		virtual/perl-Pod-Parser
		)
	"

DOCS=( AUTHORS NEWS README )
SITEFILE="50${PN}-gentoo.el"
MY_LD_LIBRARY_PATH="${WORKDIR}/${P}/lib"
MY_PATCHES=(
	"${FILESDIR}/${PV}-0001-doc-gzipped-notmuch.3-before-trying-to.patch"
	"${FILESDIR}/${PV}-0002-Rename-rst2man-to-rst2man.py-for-Gento.patch"
	"${FILESDIR}/${PV}-0003-build-eliminate-use-of-python-execfile.patch"
	)

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

src_prepare() {
	[[ "${MY_PATCHES[@]}" ]] && epatch "${MY_PATCHES[@]}"

	bindings python distutils-r1_src_prepare
	bindings python mv README README-python || die
	mv contrib/notmuch-mutt/README contrib/notmuch-mutt/README-mutt || die

	rm -f Makefile.config # assure that new Makefile.config will be generated

	if use debug; then
		append-cflags -g
		append-cxxflags -g
	fi
}

src_configure() {
	local myeconfargs=(
		--bashcompletiondir="$(get_bashcompdir)"
		--emacslispdir="${EPREFIX}/${SITELISP}/${PN}"
		--emacsetcdir="${EPREFIX}/${SITEETC}/${PN}"
		--with-gmime-version=2.6
		--zshcompletiondir="${EPREFIX}/usr/share/zsh/site-functions"
		$(use_with emacs)
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
			mv html ../python || die
			popd || die
		}
		LD_LIBRARY_PATH="${MY_LD_LIBRARY_PATH}" bindings python pydocs
	fi
}

src_test() {
	pax-mark -m notmuch
	emake download-test-databases
	LD_LIBRARY_PATH="${MY_LD_LIBRARY_PATH}" default
	pax-mark -ze notmuch
}

src_install() {
	default

	if use emacs; then
		elisp-site-file-install "${FILESDIR}/${SITEFILE}" || die
	fi

	if use nmbug; then
		dobin devel/nmbug/nmbug
		dobin devel/nmbug/nmbug-status
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
	use doc && bindings python dohtml -r python
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
