# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=BIGPRESH
DIST_VERSION=3.10
inherit perl-module

DESCRIPTION="Extremely fast, reliable form generation and processing module"
HOMEPAGE="http://www.formbuilder.org/ https://metacpan.org/release/CGI-FormBuilder"
# Explicit declaration by upstream
LICENSE="|| ( Artistic GPL-1 )"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}/${PN}-3.90.0-rt81650.patch"
)
# Templates that can be used - but they are optional
#	>=dev-perl/CGI-SSI-0.920.0

RDEPEND="dev-perl/CGI"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

optdep_notice() {
	local i;
	elog "This package has support for optional features via the following packages"
	elog "which you may want to install separately:"
	elog
	i="$(if has_version '>=dev-perl/CGI-Session-3.950.0'; then echo '[I]'; else echo '[ ]'; fi)"
	elog " $i >=dev-perl/CGI-Session-3.950.0"
	elog "     - Multi-page form persistence with CGI::FormBuilder::Multi";
	elog
	elog " Alternative Template Engines:"
	i="$(if has_version '>=dev-perl/CGI-FastTemplate-1.90.0'; then echo '[I]'; else echo '[ ]'; fi)"
	elog " $i >=dev-perl/CGI-FastTemplate-1.90.0"
	elog "     - CGI::FastTemplate via CGI::FormBuilder::Template::Fast";

	i="$(if has_version '>=dev-perl/HTML-Template-2.60.0'; then echo '[I]'; else echo '[ ]'; fi)"
	elog " $i >=dev-perl/HTML-Template-2.60.0"
	elog "     - HTML::Template    via CGI::FormBuilder::Template::HTML";

	i="$(if has_version '>=dev-perl/Template-Toolkit-2.80.0'; then echo '[I]'; else echo '[ ]'; fi)"
	elog " $i >=dev-perl/Template-Toolkit-2.80.0"
	elog "     - Template.pm       via CGI::FormBuilder::Template::TT2";

	i="$(if has_version '>=dev-perl/Text-Template-1.430.0'; then echo '[I]'; else echo '[ ]'; fi)"
	elog " $i >=dev-perl/Text-Template-1.430.0"
	elog "     - Text::Template    via CGI::FormBuilder::Template::Text";

	if use test; then
		elog
		elog "This module will perform additonal tests if these dependencies are"
		elog "pre-installed"
	fi
}

src_test() {
	optdep_notice;
	echo
	perl-module_src_test
}

pkg_postinst() {
	use test || optdep_notice;
}
