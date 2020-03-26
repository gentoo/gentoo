# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Virtual for I18N-LangTags"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 m68k ppc ppc64 s390 sparc x86 ~x64-cygwin"

RDEPEND="
	|| ( =dev-lang/perl-5.30* ~perl-core/I18N-LangTags-${PV} )
	dev-lang/perl:=
	!<perl-core/I18N-LangTags-${PV}
	!>perl-core/I18N-LangTags-${PV}-r999
"
