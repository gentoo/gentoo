# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ATOOMIC
DIST_VERSION=3.009
inherit perl-module

DESCRIPTION="The Template Toolkit"

SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="xml gd mysql postgres latex vim-syntax test"

RDEPEND="
	dev-perl/Text-Autoformat
	mysql? ( dev-perl/DBD-mysql )
	postgres? ( dev-perl/DBD-Pg )
	>=dev-perl/AppConfig-1.560.0
"
BDEPEND="${RDEPEND}
	test? ( dev-perl/CGI )
"
PDEPEND="
	dev-perl/Text-Autoformat
	vim-syntax? ( app-vim/tt2-syntax )
	xml? ( dev-perl/Template-XML )
	gd? ( dev-perl/Template-GD )
	mysql? ( dev-perl/Template-DBI )
	latex? ( dev-perl/Template-Plugin-Latex )
	postgres? ( dev-perl/Template-DBI )
"

myconf=(
	TT_XS_ENABLE=y
	TT_XS_DEFAULT=y
	TT_QUIET=y
	TT_ACCEPT=y
)

PERL_RM_FILES=(
	t/zz-plugin-leak.t
	t/zz-pmv.t
	t/zz-pod-coverage.t
	t/zz-pod-kwalitee.t
	t/zz-stash-xs-leak.t
	t/zz-url2.t
)
