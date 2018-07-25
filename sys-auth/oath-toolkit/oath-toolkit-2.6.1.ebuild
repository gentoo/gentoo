# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit pam eutils autotools
DESCRIPTION="Toolkit for using one-time password authentication with HOTP/TOTP algorithms"
HOMEPAGE="http://www.nongnu.org/oath-toolkit/"
SRC_URI="http://download.savannah.gnu.org/releases/${PN}/${P}.tar.gz"
LICENSE="GPL-3 LGPL-2.1"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="pam pskc test"

RDEPEND="
	pam? ( virtual/pam )
	pskc? ( dev-libs/xmlsec )"
DEPEND="${RDEPEND}
	test? ( dev-libs/libxml2 )
	dev-util/gtk-doc-am"

src_prepare() {
	# These tests need git/cvs and don't reflect anything in the final app
	sed -i -r \
		-e '/TESTS/s,test-vc-list-files-(git|cvs).sh,,g' \
		gl/tests/Makefile.am
	# disable portability warnings, caused by gtk-doc.make
	sed -i \
		-e '/AM_INIT_AUTOMAKE/ s:-Wall:\0 -Wno-portability:' \
		{liboath,libpskc}/configure.ac
	eautoreconf
	default
}

src_configure() {
	econf \
		$(use_enable test xmltest ) \
		$(use_enable pam) \
		$(use_with pam pam-dir $(getpam_mod_dir)) \
		$(use_enable pskc)
}

src_install() {
	default
	if use pam; then
		newdoc pam_oath/README README.pam
	fi
	if use pskc; then
		doman pskctool/pskctool.1
	fi
}

src_test() {
	# without keep-going, it will bail out after the first testsuite failure,
	# skipping the other testsuites. as they are mostly independant, this sucks.
	emake --keep-going check
	[ $? -ne 0 ] && die "At least one testsuite failed"
}
