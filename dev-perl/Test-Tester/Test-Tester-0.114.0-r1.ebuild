# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Ease testing test modules built with Test::Builder"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""
HOMEPAGE="https://www.gentoo.org/"
LICENSE="GPL-2"
# this is just a dummy ebuild to help with portage dependency resolution on
# Perl 5.22 upgrade - it does not install any files

RDEPEND="=virtual/perl-Test-Simple-1.1.14*"

removal_message() {
	einfo "This package is only a stub for upgrade purposes and can now be removed"
	einfo "Equivalent modules now should be supported by either"
	einfo " a) virtual/perl-Test-Simple installing >=perl-core/Test-Simple-1.1.14"
	einfo " b) virtual/perl-Test-Simple installing >=dev-lang/perl-5.22.0"
}

pkg_postinst() {
	removal_message
}

pkg_info() {
	removal_message
}
