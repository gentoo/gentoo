# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_4} )

PYTHON_REQ_USE="xml"

inherit python-r1 eutils

DESCRIPTION="Collection of developer scripts for Gentoo"
HOMEPAGE="https://www.gentoo.org/proj/en/portage/tools/index.xml"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

CDEPEND="
	sys-apps/portage[${PYTHON_USEDEP}]
	dev-lang/perl
	sys-apps/diffutils"
DEPEND="${PYTHON_DEPS}
	!>=app-portage/gentoolkit-0.4.0
	test? ( ${CDEPEND} )"
RDEPEND="${PYTHON_DEPS}
	${CDEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-tests.patch"
}

src_test() {
	# echangelog test is not able to run as root
	# the EUID check may not work for everybody
	if [[ ${EUID} -ne 0 ]];
	then
		python_foreach_impl emake test
	else
		ewarn "test skipped, please re-run as non-root if you wish to test ${PN}"
	fi
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
	python_replicate_script "${ED}"/usr/bin/imlate
}

pkg_postinst() {
	ewarn "This package is deprecated.  ebump, ekeyword and imlate have "
	ewarn "been moved to >=app-portage/gentoolkit-0.4.0"
	ewarn "The remaining gentoolkit-dev commands are considered deprecated"
}
