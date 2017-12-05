# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DANBERR
inherit perl-module

DESCRIPTION="API for using the libvirt library from Perl"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test examples"

RDEPEND=">=app-emulation/libvirt-${PV}"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? (
		dev-perl/XML-XPath
		virtual/perl-Time-HiRes
	)"
PATCHES=( "${FILESDIR}/no-dot-inc.patch" )
src_compile() {
	MAKEOPTS+=" -j1" perl-module_src_compile
}

src_test() {
	perl_rm_files "t/010-pod-coverage.t" "t/005-pod.t" "t/015-changes.t"
	perl-module_src_test
}

src_install() {
	perl-module_src_install
	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		dodoc examples
	fi
}
