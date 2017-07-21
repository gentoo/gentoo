# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=DANBERR
MODULE_VERSION=1.2.9
inherit perl-module

DESCRIPTION="Sys::Virt provides an API for using the libvirt library from Perl"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=">=app-emulation/libvirt-${PV}"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? (
		dev-perl/XML-XPath
		virtual/perl-Time-HiRes
	)"
PATCHES=( "${FILESDIR}/no-dot-inc.patch" )
SRC_TEST="do"

src_compile() {
	MAKEOPTS+=" -j1" perl-module_src_compile
}

src_test() {
	perl_rm_files "t/010-pod-coverage.t" "t/005-pod.t" "t/015-changes.t"
	perl-module_src_test
}
