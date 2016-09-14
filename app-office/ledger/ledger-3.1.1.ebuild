# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit check-reqs cmake-utils elisp-common python-single-r1

DESCRIPTION="A double-entry accounting system with a command-line reporting interface"
HOMEPAGE="http://ledger-cli.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="amd64 x86"
SLOT="0"
IUSE="doc emacs python"

SITEFILE=50${PN}-gentoo-${PV}.el

CHECKREQS_MEMORY=8G

COMMON_DEPEND="
	dev-libs/gmp:0
	dev-libs/mpfr:0
	emacs? ( virtual/emacs )
	python? ( dev-libs/boost:=[python] )
	!python? ( dev-libs/boost:= )
"
RDEPEND="
	${COMMON_DEPEND}
	python? ( dev-python/cheetah )
"
DEPEND="
	${COMMON_DEPEND}
	dev-libs/utfcpp
	doc? ( sys-apps/texinfo )
"

DOCS=(README.md)

# Building with python integration seems to fail without 8G available
# RAM(!)  Since the memory check in check-reqs doesn't count swap, it
# may be unfair to fail the build entirely on the memory test alone.
# Therefore check-reqs_pkg_pretend is deliberately omitted so that we
# ewarn but not not eerror.
pkg_pretend() {
	:
}
pkg_setup() {
	if use python; then
	   check-reqs_pkg_setup
	   python-single-r1_pkg_setup
	fi
}

src_prepare() {
	# Want to type "info ledger" not "info ledger3"
	sed -i -e 's/ledger3/ledger/g' \
	doc/ledger3.texi \
	doc/CMakeLists.txt \
	test/CheckTexinfo.py \
	tools/cleanup.sh \
	tools/gendocs.sh \
	tools/prepare-commit-msg \
	tools/spellcheck.sh \
	|| die "Failed to update info file name in file contents"

	mv doc/ledger{3,}.texi || die "Failed to rename info file name"
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_build emacs EMACSLISP)
		$(cmake-utils_use_build doc DOCS)
		$(cmake-utils_use_build doc WEB_DOCS)
		$(cmake-utils_use_use python PYTHON)
		-DCMAKE_INSTALL_DOCDIR=/usr/share/doc/${PF}
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	use doc && cmake-utils_src_make doc
}

src_install() {
	# Prevent installing ledger.so into python site-packages.  It's an
	# unnecessary copy of libledger.so and generates security warnings.
	sed -i -e '/python/d' ../${P}_build/src/cmake_install.cmake \
		|| die "Failed to disable installation of ledger.so"

	enable_cmake-utils_src_install

	# This source dir appears to include some helper code for serving
	# reports to a browser ("ledger server").  I can't quite get it to
	# work and the docs say it's a work-in-progress.  It's a little
	# interesting, though, so I'll leave these installed as a preview of
	# features to come.
	if use python; then
		mv python ${PN} || die "Couldn't rename python module static files dir"
		python_domodule ${PN}
	fi

	use emacs && elisp-site-file-install "${FILESDIR}/${SITEFILE}"
}

pkg_postinst() {
	use emacs && elisp-site-regen

	einfo
	einfo "Since version 3, vim support is released separately."
	einfo "See https://github.com/ledger/vim-ledger"
	einfo
}

pkg_postrm() {
	use emacs && elisp-site-regen
}

# rainy day TODO:
# - IUSE test
