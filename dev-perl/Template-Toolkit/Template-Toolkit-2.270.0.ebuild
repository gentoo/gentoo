# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ABW
DIST_VERSION=2.27
inherit perl-module

DESCRIPTION="The Template Toolkit"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~ppc-aix ~x86-fbsd ~x86-solaris"
IUSE="xml gd mysql postgres latex vim-syntax test"

RDEPEND="dev-perl/Text-Autoformat
	mysql? ( dev-perl/DBD-mysql )
	postgres? ( dev-perl/DBD-Pg )
	>=dev-perl/AppConfig-1.56"
DEPEND="${RDEPEND}
	test? ( dev-perl/CGI )
"
PDEPEND="dev-perl/Text-Autoformat
	vim-syntax? ( app-vim/tt2-syntax )
	xml? ( dev-perl/Template-XML )
	gd? ( dev-perl/Template-GD )
	mysql? ( dev-perl/Template-DBI )
	latex? ( dev-perl/Template-Plugin-Latex )
	postgres? ( dev-perl/Template-DBI )"

myconf=(
	TT_XS_ENABLE=y
	TT_XS_DEFAULT=y
	TT_QUIET=y
	TT_ACCEPT=y
)

src_prepare() {
	# Blame Makefile.PL
	use test && perl_rm_files t/zz-*.t
	perl-module_src_prepare
}
