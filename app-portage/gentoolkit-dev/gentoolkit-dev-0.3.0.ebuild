# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/gentoolkit-dev/gentoolkit-dev-0.3.0.ebuild,v 1.1 2015/05/22 16:39:00 floppym Exp $

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_3,3_4} )
PYTHON_REQ_USE="xml"

inherit python-r1

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://anongit.gentoo.org/proj/gentoolkit.git
		http://anongit.gentoo.org/git/proj/gentoolkit.git"
	EGIT_BRANCH="gentoolkit-dev"
else
	SRC_URI="http://dev.gentoo.org/~floppym/dist/${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi

DESCRIPTION="Collection of developer scripts for Gentoo"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Portage-Tools"

LICENSE="GPL-2"
SLOT="0"
IUSE="test"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

CDEPEND="
	sys-apps/portage[${PYTHON_USEDEP}]
	dev-lang/perl
	sys-apps/diffutils"
DEPEND="${PYTHON_DEPS}
	test? ( ${CDEPEND} )"
RDEPEND="${PYTHON_DEPS}
	${CDEPEND}"

src_test() {
	# echangelog test is not able to run as root
	# the EUID check may not work for everybody
	if [[ ${EUID} -ne 0 ]]; then
		python_foreach_impl emake test
	else
		ewarn "test skipped, please re-run as non-root if you wish to test ${PN}"
	fi
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
	python_replicate_script "${ED}"/usr/bin/{ekeyword,imlate}
}
