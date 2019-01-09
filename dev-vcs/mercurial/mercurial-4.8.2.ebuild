# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads"

inherit bash-completion-r1 elisp-common eutils distutils-r1 flag-o-matic

DESCRIPTION="Scalable distributed SCM"
HOMEPAGE="https://www.mercurial-scm.org/"
SRC_URI="https://www.mercurial-scm.org/release/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc64 ~sparc ~x86 ~ppc-aix ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="bugzilla emacs gpg test tk"

RDEPEND="app-misc/ca-certificates
	dev-python/zstandard[${PYTHON_USEDEP}]
	bugzilla? ( dev-python/mysql-python[${PYTHON_USEDEP}] )
	gpg? ( app-crypt/gnupg )
	tk? ( dev-lang/tk )"

DEPEND="emacs? ( virtual/emacs )
	test? ( app-arch/unzip
		dev-python/pygments[${PYTHON_USEDEP}] )"

SITEFILE="70${PN}-gentoo.el"

PATCHES=(
	"${FILESDIR}/${PN}-3.0.1-po_fixes.patch"
	"${FILESDIR}/${PN}-4.8.1-unbundle_zstd.patch"
)

python_prepare_all() {
	# fix up logic that won't work in Gentoo Prefix (also won't outside in
	# certain cases), bug #362891
	sed -i -e 's:xcodebuild:nocodebuild:' setup.py || die

	# Don't use bundled zstandard (#666972)
	rm -r contrib/python-zstandard || die

	distutils-r1_python_prepare_all
}

python_configure_all() {
	strip-flags -ftracer -ftree-vectorize
	# Note: make it impl-conditional if py3 is supported
	append-flags -fno-strict-aliasing

	"${PYTHON}" setup.py build_mo || die
}

python_compile_all() {
	rm -r contrib/win32 || die
	if use emacs; then
		cd contrib || die
		elisp-compile mercurial.el || die "elisp-compile failed!"
	fi
}

python_install_all() {
	distutils-r1_python_install_all

	newbashcomp contrib/bash_completion hg

	insinto /usr/share/zsh/site-functions
	newins contrib/zsh_completion _hg

	rm -f doc/*.?.txt
	dodoc CONTRIBUTORS
	cp hgweb*.cgi "${ED}"/usr/share/doc/${PF}/ || die

	dobin hgeditor
	dobin contrib/hgk
	python_foreach_impl python_doscript contrib/hg-ssh

	if use emacs; then
		elisp-install ${PN} contrib/mercurial.el* || die "elisp-install failed!"
		elisp-site-file-install "${FILESDIR}"/${SITEFILE}
	fi

	local RM_CONTRIB=( hgk hg-ssh bash_completion zsh_completion wix plan9 *.el )
	for f in ${RM_CONTRIB[@]}; do
		rm -r contrib/${f} || die
	done

	dodoc -r contrib
	docompress -x /usr/share/doc/${PF}/contrib
	doman doc/*.?

	insinto /etc/mercurial/hgrc.d
	doins "${FILESDIR}/cacerts.rc"

	# symlink to system zstd
	local sitedir=$(python_get_sitedir)
	dosym ../zstd.so "${sitedir#${EPREFIX}}"/${PN}/zstd.so
}

src_test() {
	pushd tests &>/dev/null || die
	rm -rf *svn*			# Subversion tests fail with 1.5
	rm -f test-archive*		# Fails due to verbose tar output changes
	rm -f test-convert-baz*		# GNU Arch baz
	rm -f test-convert-cvs*		# CVS
	rm -f test-convert-darcs*	# Darcs
	rm -f test-convert-git*		# git
	rm -f test-convert-mtn*		# monotone
	rm -f test-convert-tla*		# GNU Arch tla
	#rm -f test-doctest*		# doctest always fails with python 2.5.x
	rm -f test-largefiles*		# tends to time out

	popd &>/dev/null || die
	distutils-r1_src_test
}

python_test() {
	local TEST_DIR

	rm -rf "${TMPDIR}"/test
	distutils_install_for_testing
	cd tests || die
	"${PYTHON}" run-tests.py --verbose \
		--tmpdir="${TMPDIR}"/test \
		--with-hg="${TEST_DIR}"/scripts/hg \
		|| die "Tests fail with ${EPYTHON}"
}

pkg_postinst() {
	use emacs && elisp-site-regen

	elog "If you want to convert repositories from other tools using convert"
	elog "extension please install correct tool:"
	elog "  dev-vcs/cvs"
	elog "  dev-vcs/darcs"
	elog "  dev-vcs/git"
	elog "  dev-vcs/monotone"
	elog "  dev-vcs/subversion"
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
