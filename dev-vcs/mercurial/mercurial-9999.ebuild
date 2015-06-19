# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-vcs/mercurial/mercurial-9999.ebuild,v 1.22 2015/04/08 17:53:02 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads"

inherit bash-completion-r1 elisp-common eutils distutils-r1 mercurial flag-o-matic

DESCRIPTION="Scalable distributed SCM"
HOMEPAGE="http://mercurial.selenic.com/"
EHG_REPO_URI="http://selenic.com/repo/hg"
EHG_REVISION="@"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="bugzilla emacs gpg test tk zsh-completion"

RDEPEND="bugzilla? ( dev-python/mysql-python[${PYTHON_USEDEP}] )
	gpg? ( app-crypt/gnupg )
	tk? ( dev-lang/tk )
	zsh-completion? ( app-shells/zsh )
	app-misc/ca-certificates"
DEPEND="emacs? ( virtual/emacs )
	test? ( app-arch/unzip
		dev-python/pygments[${PYTHON_USEDEP}] )
	dev-python/docutils[${PYTHON_USEDEP}]"

SITEFILE="70${PN}-gentoo.el"

python_prepare_all() {
	# fix up logic that won't work in Gentoo Prefix (also won't outside in
	# certain cases), bug #362891
	sed -i -e 's:xcodebuild:nocodebuild:' setup.py || die

	distutils-r1_python_prepare_all
}

python_configure_all() {
	strip-flags -ftracer -ftree-vectorize
	# Note: make it impl-conditional if py3 is supported
	append-flags -fno-strict-aliasing

	"${PYTHON}" setup.py build_mo || die
}

python_compile_all() {
	rm -r contrib/{win32,macosx} || die
	emake doc
	if use emacs; then
		cd contrib || die
		elisp-compile mercurial.el || die "elisp-compile failed!"
	fi
}

python_install_all() {
	distutils-r1_python_install_all

	newbashcomp contrib/bash_completion hg

	if use zsh-completion ; then
		insinto /usr/share/zsh/site-functions
		newins contrib/zsh_completion _hg
	fi

	rm -f doc/*.?.txt || die
	dodoc CONTRIBUTORS doc/*.txt
	cp hgweb*.cgi "${ED}"/usr/share/doc/${PF}/ || die

	dobin hgeditor
	dobin contrib/hgk
	python_foreach_impl python_doscript contrib/hg-ssh

	if use emacs; then
		elisp-install ${PN} contrib/mercurial.el* || die "elisp-install failed!"
		elisp-site-file-install "${FILESDIR}"/${SITEFILE}
	fi

	local RM_CONTRIB=(hgk hg-ssh bash_completion zsh_completion wix buildrpm plan9
	                  *.el mercurial.spec)
	for f in ${RM_CONTRIB[@]}; do
		rm -rf contrib/$f || die
	done

	dodoc -r contrib
	docompress -x /usr/share/doc/${PF}/contrib
	doman doc/*.?

	cat > "${T}/80mercurial" <<-EOF
HG="${EPREFIX}/usr/bin/hg"
EOF
	doenvd "${T}/80mercurial"

	insinto /etc/mercurial/hgrc.d
	doins "${FILESDIR}/cacerts.rc"
}

src_test() {
	cd tests || die
	rm -rf *svn* || die					# Subversion tests fail with 1.5
	rm -f test-archive* || die			# Fails due to verbose tar output changes
	rm -f test-convert-baz* || die		# GNU Arch baz
	rm -f test-convert-cvs* || die		# CVS
	rm -f test-convert-darcs* || die	# Darcs
	rm -f test-convert-git* || die		# git
	rm -f test-convert-mtn* || die		# monotone
	rm -f test-convert-tla* || die		# GNU Arch tla
	rm -f test-doctest* || die			# doctest always fails with python 2.5.x
	rm -f test-largefiles* || die		# tends to time out
	if [[ ${EUID} -eq 0 ]]; then
		einfo "Removing tests which require user privileges to succeed"
		rm -f test-command-template* || die	# Test is broken when run as root
		rm -f test-convert* || die			# Test is broken when run as root
		rm -f test-lock-badness* || die		# Test is broken when run as root
		rm -f test-permissions* || die		# Test is broken when run as root
		rm -f test-pull-permission* || die	# Test is broken when run as root
		rm -f test-clone-failure* || die
		rm -f test-journal-exists* || die
		rm -f test-repair-strip* || die
	fi

	cd .. || die
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
