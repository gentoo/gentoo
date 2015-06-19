# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Sys-Virt/Sys-Virt-1.2.9.ebuild,v 1.1 2014/12/07 11:53:29 maksbotan Exp $

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
		dev-perl/CPAN-Changes
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
		dev-perl/XML-XPath
		virtual/perl-Time-HiRes
	)"

SRC_TEST="do"

src_compile() {
	MAKEOPTS+=" -j1" perl-module_src_compile
}
