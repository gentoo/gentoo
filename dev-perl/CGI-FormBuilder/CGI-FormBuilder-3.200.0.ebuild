# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BIGPRESH
DIST_VERSION=3.20
inherit perl-module optfeature

DESCRIPTION="Extremely fast, reliable form generation and processing module"
HOMEPAGE="http://www.formbuilder.org/ https://metacpan.org/release/CGI-FormBuilder"

# Explicit declaration by upstream
LICENSE="|| ( Artistic GPL-1 )"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"

# Templates that can be used - but they are optional
#	>=dev-perl/CGI-SSI-0.920.0
RDEPEND="dev-perl/CGI"
BDEPEND="${RDEPEND}"

pkg_postinst() {
	# These can be used by tests too
	optfeature "Multi-page form persistence with CGI::FormBuilder::Multi" dev-perl/CGI-Session

	optfeature_header "Install alternative template engines:"
	optfeature "CGI::FastTemplate via CGI::FormBuilder::Template::Fast" dev-perl/CGI-FastTemplate
	optfeature "HTML::Template via CGI::FormBuilder::Template::HTML" dev-perl/HTML-Template
	optfeature "Template.pm via CGI::FormBuilder::Template::TT2" dev-perl/Template-Toolkit
	optfeature "Text::Template via CGI::FormBuilder::Template::Text" dev-perl/Text-Template
}
