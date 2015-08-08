# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils eutils versionator

DESCRIPTION="bzrtools is a useful collection of utilities for bzr"
HOMEPAGE="http://bazaar-vcs.org/BzrTools"
SRC_URI="https://launchpad.net/${PN}/stable/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~ia64 ppc ppc64 sparc x86 ~x86-interix ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""
#IUSE="test"

RDEPEND="|| ( =dev-vcs/bzr-2.4*
	=dev-vcs/bzr-2.5* )"
DEPEND="${RDEPEND}"
#	test? ( dev-python/testtools )"

RESTRICT="test"

S="${WORKDIR}/${PN}"

DOCS="AUTHORS CREDITS NEWS NEWS.Shelf README README.Shelf TODO TODO.heads TODO.Shelf"
PYTHON_MODNAME="bzrlib/plugins/bzrtools"

src_test() {
	testing() {
		local return_status="0"

		# put a linked copy of the bzr core into the build directory to properly
		# test the "built" version of bzrtools
		find "$(python_get_libdir)/site-packages/bzrlib/" \
			-mindepth 1 -maxdepth 1 \
			\( \( -type d -and -not -name "plugins" \) -or -name "*.py" \) \
			-exec ln -s '{}' "${S}/build-${PYTHON_ABI}/lib/bzrlib/" \;
		touch "${S}/build-${PYTHON_ABI}/lib/bzrlib/plugins/__init__.py"
		"${S}/test.py" "${S}/build-${PYTHON_ABI}/lib" || return_status="1"
		# remove the "shadow" copy so it doesn't get installed
		rm "${S}/build-${PYTHON_ABI}/lib/bzrlib/plugins/__init__.py"
		find "${S}/build-${PYTHON_ABI}/lib/bzrlib/" -mindepth 1 -maxdepth 1 -type l -exec rm '{}' \;

		return "${return_status}"
	}
	python_execute_function testing
}
