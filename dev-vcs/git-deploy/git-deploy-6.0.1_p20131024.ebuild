# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-vcs/git-deploy/git-deploy-6.0.1_p20131024.ebuild,v 1.1 2014/02/22 14:28:04 idl0r Exp $

EAPI=5

inherit perl-app

COMMIT="e9ef93debd12d85e70676dd79b4bd78ac2b05271"

DESCRIPTION="make deployments so easy that you'll let new hires do them on their
first day"
HOMEPAGE="https://github.com/git-deploy/git-deploy"
SRC_URI="https://github.com/${PN}/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

COMMON_DEPEND="dev-vcs/git
	virtual/perl-File-Spec
	virtual/perl-Getopt-Long
	virtual/perl-Term-ANSIColor
	virtual/perl-Time-HiRes
	virtual/perl-Memoize
	virtual/perl-Data-Dumper"
DEPEND="dev-lang/perl
	test? (
		${COMMON_DEPEND}
		virtual/perl-File-Temp
		)"
RDEPEND="dev-lang/perl
${COMMON_DEPEND}"

S="${WORKDIR}/${PN}-${COMMIT}"

src_prepare() {
	pod2man -n git-deploy README.pod > git-deploy.1 || die
}

src_test() {
	local testdir=${TMPDIR}/git-deploy-test

	# Prepare for tests
	cp -a "${S}/" $testdir || die
	cd $testdir || die

	git config --global user.name "git-deploy" || die
	git config --global user.email "git-deploy@localhost" || die

	git init . || die
	git add . || die
	git commit -a -m 'git-deploy testing' || die

	USER="git-deploy" perl t/run.t || die
}

src_install() {
	dobin git-deploy

	insinto $VENDOR_LIB
	doins -r lib/Git

	doman git-deploy.1

	newdoc Changes ChangeLog
}
